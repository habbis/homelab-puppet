# proxmox_vm

Puppet module that creates and manages Proxmox VE QEMU VMs through the `qm` CLI.
It runs on the Proxmox nodes themselves (no API tokens needed) and is idempotent:
every `qm` call is guarded by a read-only check (`/usr/local/sbin/puppet-qm-check`).

## Usage

```puppet
# On each Proxmox node
include proxmox_vm
```

Define VMs in Hiera (see `examples/hiera.yaml`), or declare them directly:

```puppet
proxmox_vm::vm { 'web01':
  vmid      => 201,
  template  => 9000,
  cores     => 2,
  memory    => 4096,
  disk_gb   => 40,
  ciuser    => 'admin',
  ssh_keys  => ['ssh-ed25519 AAAA... admin@ws'],
  ipconfig0 => 'ip=10.0.10.21/24,gw=10.0.10.1',
}
```

## What it does, in order

1. **Create** – `qm clone` (template), `qm create … import-from=` (cloud image),
   or `qm create` with an empty disk (+ ISO). Skipped if the VMID exists anywhere in the cluster.
2. **Configure** – `qm set` for name, CPU, memory, net0, tags, onboot, agent, cloud-init
   and `extra_config`; runs only when `qm config` differs.
3. **Resize** – `qm resize` up to `disk_gb` (grow only).
4. **SSH keys** – written to a file and applied with `qm set --sshkeys`.
5. **Power** – `ensure => running` starts it, `stopped` shuts it down,
   `present` leaves it alone, `absent` stops and **destroys the VM and its disks**.

## Notes

* Resources only apply on the node named in `node` (defaults to the node Puppet runs on),
  so one Hiera dataset can be applied cluster-wide.
* `qm clone` must run on the node holding the template; keep a template per node
  or put it on shared storage.
* Config changes such as cores/memory are written immediately but most need a
  VM reboot to take effect; the module does not reboot running VMs.
* Removing a setting from Puppet data does not remove it from the VM (use
  `extra_config` with `qm set` semantics, or `qm set --delete` manually).
* Don't put passwords here; use `ssh_keys`. If you need `cipassword`, pass a
  `Sensitive` value through your own exec.
* Requires `puppetlabs/stdlib` >= 9.
