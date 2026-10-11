# Install kubeadm to setup kubernetes
class roles::kubeadm (
# @param kubernetes_version
# @param crio_version
  String  $kubernetes_version,) {

if $facts['check_swap'] != 'off' {
  exec {
    'kubeadm_disable_swap':
      command => 'swapoff -a',
      path    => ['/bin','/usr/bin', '/usr/sbin'],
    }

  exec {
    'kubeadm_remove_swap_fstab':
      command => "sed -i 's!/dev/mapper/vg0-swap none!#/dev/mapper/vg0-swap!g' /etc/fstab",
      path    => ['/bin','/usr/bin', '/usr/sbin'],
    }

  exec {
    'kubeadm_mount':
      command => 'mount -a',
      path    => ['/bin','/usr/bin', '/usr/sbin'],
    }

  exec {
    'kubeadm_systemd_daemon_reload':
      command => 'systemctl daemon-reload',
      path    => ['/bin','/usr/bin', '/usr/sbin'],
    }
  }

if $facts['os']['family'] == 'Debian' {
  package {
    'apt-transport-https':  ensure => installed;
    'ca-certificates':      ensure => installed;
    'gpg':                  ensure => installed;
    }

  file { '/etc/apt/keyrings':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/apt/keyrings/cri-o-apt-keyring.gpg':
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => "puppet:///modules/roles/cri-o/${kubernetes_version}/debian/gpg/cri-o-apt-keyring.gpg"
      }

  file { '/etc/apt/sources.list.d/cri-o.list':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => epp("roles/cri-o/${kubernetes_version}/debian/cri-o.list.epp");
      }

  file { '/etc/apt/keyrings/kubernetes-apt-keyring.gpg':
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => "puppet:///modules/roles/kubeadm/${kubernetes_version}/debian/gpg/kubernetes-apt-keyring.gpg"
      }

  file { '/etc/apt/sources.list.d/kubernetes.list':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => epp("roles/kubeadm/${kubernetes_version}/debian/kubernetes.list.epp");
      }

  file { '/etc/sysctl.d/90-kubernetes-networking.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => epp('roles/kubeadm/90-kubernetes-networking.conf.epp');
      }

  exec {
    'kubeadm_sysctl':
      command     => 'sysctl --system',
      path        => ['/bin','/usr/bin', '/usr/sbin'],
      subscribe   => File['/etc/sysctl.d/90-kubernetes-networking.conf'],
      refreshonly => true
    }

  file { '/etc/modules-load.d/br_netfilter.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => epp('roles/kubeadm/br_netfilter.conf.epp');
      }

  exec {
    'kubeadm_update_grub':
      command     => 'update-grub',
      path        => ['/bin','/usr/bin', '/usr/sbin'],
      subscribe   => File['/etc/sysctl.d/90-kubernetes-networking.conf'],
      refreshonly => true
    }

  exec {
    'kubeadm_apt_update':
      command     => 'apt-get update',
      path        => ['/bin','/usr/bin', '/usr/sbin'],
      subscribe   => File['/etc/apt/sources.list.d/kubernetes.list'],
      refreshonly => true
    }

  package {
    'cri-o':   ensure => installed;
    'kubelet': ensure => installed;
    'kubeadm': ensure => installed;
    'kubectl': ensure => installed;
    }

  file { '/etc/systemd/system/crio.service.d':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { '/etc/modules-load.d/http-proxy.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => epp('roles/kubeadm/http-proxy.conf.epp');
      }

    service {
      'crio':
        ensure    => running,
        enable    => true,
        hasstatus => true,
    }
  }
}
