# Class for specific redhat packages
class server_lite::packages::redhat {
  if $operatingsystemrelease !~ /^5.*/ {
    package {
      'xz':                ensure => installed;
      'vim-enhanced':      ensure => installed;
      'coreutils':         ensure => installed;
      'bind-utils':        ensure => installed;
      'sysstat':           ensure => installed;
      'virt-what':         ensure => installed;
      'net-tools': ensure => installed;
      'tldr': ensure => installed;
      'yum-utils': ensure => installed;
    }
  }
}
