# @summary
#   Create and manage one Proxmox VE QEMU VM using the `qm` CLI.
#
# Exactly one of `template`, `image` or `iso` may be set:
#   * template - clone an existing VM template (must live on `node`)
#   * image    - create a VM and import a cloud image (qcow2/raw) on the node
#   * iso      - create a VM with an empty disk and the ISO attached as CD-ROM
#   * none     - create a VM with an empty disk
#
# VM identity:
#   * With `vmid` set, the VM is identified by that ID.
#   * Without `vmid`, the VM is identified by its name (the resource title).
#     On creation the next free ID is taken from `pvesh get /cluster/nextid`
#     (honours the datacenter "next-id" range). Names must then be unique
#     across the cluster; duplicates make the run fail instead of guessing.
#
# Resources are only applied when Puppet runs on `node`, so the same
# catalog data can be applied to every node in a cluster.
#
# @param vmid          Proxmox VM ID (cluster-unique). Optional: omit to auto-assign.
# @param ensure        present | running | stopped | absent (absent destroys the VM and its disks!).
# @param node          Proxmox node that should own the VM.
# @param template      VM ID of a template to clone.
# @param full_clone    Full clone (true) or linked clone (false) when using `template`.
# @param image         Absolute path on the node to a cloud image to import.
# @param iso           ISO volume, e.g. 'local:iso/debian-12.7.0-amd64-netinst.iso'.
# @param storage       Storage for disks and the cloud-init drive.
# @param disk          Bus/slot of the main disk.
# @param disk_gb       Disk size in GB. Disks are only ever grown, never shrunk.
# @param cores         CPU cores per socket.
# @param sockets       CPU sockets.
# @param memory        Memory in MB.
# @param cpu           CPU type.
# @param ostype        Guest OS type (l26, win11, ...).
# @param bridge        Bridge for net0.
# @param vlan          Optional VLAN tag for net0.
# @param net_model     NIC model for net0.
# @param onboot        Start the VM when the node boots.
# @param agent         Enable the QEMU guest agent option.
# @param tags          Proxmox tags.
# @param description   Single-line VM description / notes.
# @param ciuser        Cloud-init user.
# @param ssh_keys      Cloud-init authorized SSH public keys.
# @param ipconfig0     Cloud-init IP config, e.g. 'ip=dhcp' or 'ip=10.0.0.5/24,gw=10.0.0.1'.
# @param nameserver    Cloud-init DNS server(s).
# @param searchdomain  Cloud-init DNS search domain.
# @param extra_config  Any other `qm set` options, e.g. { 'serial0' => 'socket', 'vga' => 'serial0' }.
# @param timeout       Timeout in seconds for create/clone/import.
#
define proxmox_vm::vm (
  Optional[Integer[100, 999999999]]           $vmid         = undef,
  Enum['present', 'running', 'stopped', 'absent'] $ensure   = 'running',
  String[1]                                   $node         = $facts['networking']['hostname'],
  Optional[Integer[100, 999999999]]           $template     = undef,
  Boolean                                     $full_clone   = true,
  Optional[Stdlib::Absolutepath]              $image        = undef,
  Optional[Pattern[/^[\w.-]+:iso\/[^\s,]+$/]] $iso          = undef,
  Pattern[/^[\w.-]+$/]                        $storage      = 'local-lvm',
  Pattern[/^(scsi|virtio|sata|ide)\d+$/]      $disk         = 'scsi0',
  Optional[Integer[1]]                        $disk_gb      = 32,
  Integer[1, 512]                             $cores        = 2,
  Integer[1, 8]                               $sockets      = 1,
  Integer[16]                                 $memory       = 2048,
  String[1]                                   $cpu          = 'host',
  String[1]                                   $ostype       = 'l26',
  Pattern[/^[\w.-]+$/]                        $bridge       = 'vmbr0',
  Optional[Integer[1, 4094]]                  $vlan         = undef,
  Enum['virtio', 'e1000', 'e1000e', 'rtl8139', 'vmxnet3'] $net_model = 'virtio',
  Boolean                                     $onboot       = true,
  Boolean                                     $agent        = true,
  Array[Pattern[/^[\w.-]+$/]]                 $tags         = [],
  Optional[Pattern[/^[^\n]+$/]]               $description  = undef,
  Optional[String[1]]                         $ciuser       = undef,
  Array[String[1]]                            $ssh_keys     = [],
  Optional[String[1]]                         $ipconfig0    = undef,
  Optional[String[1]]                         $nameserver   = undef,
  Optional[String[1]]                         $searchdomain = undef,
  Hash[Pattern[/^[a-z][a-z0-9]*$/], Scalar]   $extra_config = {},
  Integer[1]                                  $timeout      = 1800,
) {
  include proxmox_vm

  assert_type(Pattern[/^[A-Za-z0-9]([A-Za-z0-9.-]*[A-Za-z0-9])?$/], $title) |$expected, $actual| {
    fail("proxmox_vm::vm: '${title}' is not a valid VM name (must be a DNS name)")
  }

  $sources = [$template, $image, $iso].filter |$s| { $s =~ NotUndef }
  if $sources.length > 1 {
    fail("proxmox_vm::vm[${title}]: set only one of template, image or iso")
  }

  # Only act on the node that owns this VM.
  if $node == $facts['networking']['hostname'] {
    $helper = '/usr/local/sbin/puppet-qm-check'

    # How to refer to the VM:
    #   $ref  - argument for the helper (VMID or name:<name>)
    #   $pre  - shell prefix that resolves the VMID at run time
    #   $id   - the VMID as used in qm commands
    if $vmid =~ NotUndef {
      $ref = String($vmid)
      $pre = ''
      $id  = String($vmid)
    } else {
      $ref = "name:${title}"
      $pre = "vmid=\$(${helper} id ${ref}) && "
      $id  = '"$vmid"'
    }

    Exec {
      path      => ['/usr/sbin', '/usr/bin', '/sbin', '/bin'],
      provider  => 'shell',
      logoutput => 'on_failure',
    }

    $keyfile = "${proxmox_vm::state_dir}/${title}.pub"

    if $ensure == 'absent' {
      exec { "proxmox_vm ${title} destroy":
        command => "${pre}{ qm stop ${id} >/dev/null 2>&1; qm destroy ${id} --purge 1 --destroy-unreferenced-disks 1; }",
        onlyif  => "${helper} local ${ref}",
        timeout => $timeout,
        require => File[$helper],
      }
      file { $keyfile:
        ensure => absent,
      }
    } else {
      # ---------------------------------------------------------------
      # 1. Create (clone / import / blank) if the VM doesn't exist anywhere
      # ---------------------------------------------------------------
      $q_name    = stdlib::shell_escape($title)
      $q_storage = stdlib::shell_escape($storage)

      $net0_parts = [$net_model, "bridge=${bridge}"] + ($vlan ? { undef => [], default => ["tag=${vlan}"] })
      $net0 = $net0_parts.join(',')

      # New VMID: fixed, or the next free one at creation time.
      $new_pre = $vmid ? {
        undef   => 'vmid=$(pvesh get /cluster/nextid | tr -dc 0-9) && [ -n "$vmid" ] && ',
        default => '',
      }

      if $template {
        $clone_opts = $full_clone ? {
          true  => "--full 1 --storage ${q_storage}",
          false => '--full 0',
        }
        $create_cmd = "${new_pre}qm clone ${template} ${id} --name ${q_name} ${clone_opts}"
      } else {
        $size = pick($disk_gb, 32)
        $disk_opt = $image ? {
          undef   => "--${disk} ${q_storage}:${size}",
          default => "--${disk} ${q_storage}:0,import-from=${stdlib::shell_escape($image)}",
        }
        $media_opt = $iso ? {
          undef   => $image ? {
            undef   => '',
            default => "--ide2 ${q_storage}:cloudinit",
          },
          default => "--ide2 ${stdlib::shell_escape("${iso},media=cdrom")}",
        }
        $boot = $iso ? {
          undef   => "order=${disk}",
          default => "order=${disk};ide2",
        }
        $create_cmd = [
          "${new_pre}qm create ${id} --name ${q_name}",
          "--memory ${memory} --cores ${cores} --sockets ${sockets}",
          "--cpu ${stdlib::shell_escape($cpu)} --ostype ${stdlib::shell_escape($ostype)}",
          '--scsihw virtio-scsi-single',
          "--net0 ${stdlib::shell_escape($net0)}",
          $disk_opt,
          $media_opt,
          "--boot ${stdlib::shell_escape($boot)}",
        ].filter |$p| { !$p.empty }.join(' ')
      }

      exec { "proxmox_vm ${title} create":
        command => $create_cmd,
        unless  => "${helper} exists ${ref}",
        timeout => $timeout,
        require => File[$helper],
      }

      # ---------------------------------------------------------------
      # 2. Converge configuration with `qm set` (only when it differs)
      # ---------------------------------------------------------------
      $settings = ({
        'name'         => $title,
        'cores'        => $cores,
        'sockets'      => $sockets,
        'memory'       => $memory,
        'cpu'          => $cpu,
        'ostype'       => $ostype,
        'net0'         => $net0,
        'onboot'       => $onboot ? { true => 1, false => 0 },
        'agent'        => $agent ? { true => 1, false => 0 },
        'tags'         => $tags.empty ? { true => undef, false => $tags.join(';') },
        'description'  => $description,
        'ciuser'       => $ciuser,
        'ipconfig0'    => $ipconfig0,
        'nameserver'   => $nameserver,
        'searchdomain' => $searchdomain,
      } + $extra_config).filter |$k, $v| { $v =~ NotUndef }

      $set_args   = $settings.map |$k, $v| { "--${k} ${stdlib::shell_escape(String($v))}" }.join(' ')
      $check_args = $settings.map |$k, $v| { stdlib::shell_escape("${k}=${v}") }.join(' ')

      exec { "proxmox_vm ${title} configure":
        command => "${pre}qm set ${id} ${set_args}",
        unless  => "${helper} config ${ref} ${check_args}",
        require => Exec["proxmox_vm ${title} create"],
      }

      # ---------------------------------------------------------------
      # 3. Grow the disk (never shrinks)
      # ---------------------------------------------------------------
      if $disk_gb {
        exec { "proxmox_vm ${title} resize ${disk}":
          command => "${pre}qm resize ${id} ${disk} ${disk_gb}G",
          unless  => "${helper} disk-ge ${ref} ${disk} ${disk_gb}G",
          require => Exec["proxmox_vm ${title} configure"],
        }
        $before_power = Exec["proxmox_vm ${title} resize ${disk}"]
      } else {
        $before_power = Exec["proxmox_vm ${title} configure"]
      }

      # ---------------------------------------------------------------
      # 4. Cloud-init SSH keys (qm needs them in a file)
      # ---------------------------------------------------------------
      if $ssh_keys.empty {
        file { $keyfile: ensure => absent }
      } else {
        file { $keyfile:
          ensure  => file,
          owner   => 'root',
          group   => 'root',
          mode    => '0600',
          content => "${ssh_keys.join("\n")}\n",
        }
        exec { "proxmox_vm ${title} sshkeys":
          command => "${pre}qm set ${id} --sshkeys ${keyfile}",
          unless  => "${helper} sshkeys ${ref} ${keyfile}",
          require => [Exec["proxmox_vm ${title} configure"], File[$keyfile]],
          before  => $before_power,
        }
      }

      # ---------------------------------------------------------------
      # 5. Power state
      # ---------------------------------------------------------------
      case $ensure {
        'running': {
          exec { "proxmox_vm ${title} start":
            command => "${pre}qm start ${id}",
            unless  => "${helper} status ${ref} running",
            require => $before_power,
          }
        }
        'stopped': {
          exec { "proxmox_vm ${title} shutdown":
            command => "${pre}qm shutdown ${id} --timeout 180 --forceStop 1",
            unless  => "${helper} status ${ref} stopped",
            timeout => 300,
            require => $before_power,
          }
        }
        default: {} # present: leave power state alone
      }
    }
  }
}
