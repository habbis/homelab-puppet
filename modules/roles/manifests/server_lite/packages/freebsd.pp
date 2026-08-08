#Class for freebsd specific packages
class roles::server_lite::packages::freebsd {
  file { '/etc/pkg/FreeBSD.conf':
    ensure  => present,
    owner   => root,
    group   => wheel,
    mode    => '0644',
    content => epp('roles/pkg/FreeBSD.conf.epp'),
    }

  package {
    'pwgen':           ensure => installed;
    'virt-what':       ensure => installed;
    'tldr':            ensure => installed;
    'netcat':          ensure => installed;
    'psmisc':          ensure => installed;
    'bash':            ensure => installed;
    'bash-completion': ensure => installed;
    'sudo':            ensure => installed;
    'tmux':            ensure => installed;
    'python-3.12_3,2': ensure => installed;
    'py312-pip':       ensure => installed;
    'vim':       ensure => installed;
  }
}
