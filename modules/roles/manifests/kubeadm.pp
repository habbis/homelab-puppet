# setup mariadb server internal repo unix servers
class roles::kubeadm (
# @param kubernetes_version
# @param crio_version
  String  $kubernetes_version,) {


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

  exec {
    'kubeadm_apt_update':
      command => 'apt-get update',
      path    => ['/bin','/usr/bin', '/usr/sbin'],
    }

  package {
    'cri-o':   ensure => installed;
    'kubelet': ensure => installed;
    'kubeadm': ensure => installed;
    'kubectl': ensure => installed;
    }
  }
}

