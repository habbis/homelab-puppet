# Class for specific redhat packages
class roles::server_lite::packages::redhat {
  if  $facts['os']['family'] =='RedHat' {
    package {
      'xz':              ensure => installed;
      'vim-enhanced':    ensure => installed;
      'coreutils':       ensure => installed;
      'bind-utils':      ensure => installed;
      'sysstat':         ensure => installed;
      'virt-what':       ensure => installed;
      'net-tools':       ensure => installed;
      'tldr':            ensure => absent;
      'yum-utils':       ensure => installed;
    }
  }
}
