#Class for Debian specific packages
class roles::server_lite::packages::debian {
  package {
    'chase':     ensure => installed;
    'iotop':     ensure => installed;
    'pwgen':     ensure => installed;
    'xz-utils':  ensure => installed;
    'cron-apt':  ensure => installed;
    'sysstat':   ensure => installed;
    'virt-what': ensure => installed;
    'net-tools': ensure => installed;
    'netcat-openbsd': ensure => installed;
    'locales-all': ensure => installed;
    'psmisc': ensure => installed;
  }

  if $facts['os']['release']['major'] == '12' {
  package {
    'dnsutils':  ensure => installed;
    }
  }

  if $facts['os']['release']['major'] == '13' {
  package {
    'bind9-dnsutils':  ensure => installed;
    }
  }

  if ! defined(Package['vim']) {
    package {
      'vim':       ensure => installed;
    }
  }

}
