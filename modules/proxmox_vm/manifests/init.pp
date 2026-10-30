# @summary
#   Manage QEMU virtual machines on a Proxmox VE node via the `qm` CLI.
#
# Apply this class to your Proxmox nodes. Each VM is created only on the
# node named in its `node` parameter (default: the node Puppet runs on).
#
# @param vms
#   Hash of VMs, keyed by VM name. Values are parameters for proxmox_vm::vm.
# @param defaults
#   Parameters merged into every entry of `vms` (per-VM values win).
# @param state_dir
#   Where cloud-init argument and SSH key files are kept.
#
# @example Hiera
#   proxmox_vm::defaults:
#     storage: 'local-lvm'
#     bridge: 'vmbr0'
#   proxmox_vm::vms:
#     web01:
#       vmid: 201
#       template: 9000
#       cores: 2
#       memory: 4096
#
class proxmox_vm (
  Hash[String[1], Hash] $vms       = {},
  Hash                  $defaults  = {},
  String[1]             $state_dir = '/var/lib/puppet-proxmox_vm',
) {
  file { $state_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  # Idempotency checks used by the qm execs.
  file { '/usr/local/sbin/puppet-qm-check':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/proxmox_vm/puppet-qm-check',
  }

  $vms.each |String $vm_name, Hash $params| {
    proxmox_vm::vm { $vm_name:
      * => $defaults + $params,
    }
  }
}
