# Install kubeadm to setup kubernetes
class roles::kubectl (
# @param kubernetes_version
# @param crio_version
  String  $kubernetes_version,) {

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
    'kubectl_apt_update':
      command     => 'apt-get update',
      path        => ['/bin','/usr/bin', '/usr/sbin'],
      subscribe   => File['/etc/apt/sources.list.d/kubernetes.list'],
      refreshonly => true
    }

  package {
    'kubectl': ensure => installed;
  }
}
