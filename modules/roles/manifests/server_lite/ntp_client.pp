# Class for setting up ntp client on unix server
class roles::server_lite::ntp_client {
if  $facts['ntp_server'] == false {
  if $facts['kernel'] == 'Linux' {
  package {
    'chrony':  ensure => installed;
    }
  }

  if  $facts['os']['family'] =='RedHat' {
    file { '/etc/chrony.conf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('roles/chrony/rhel_chrony.conf.erb');
    }
    service {
      'chronyd':
        ensure     => running,
        require    => Package['chrony'],
        enable     => true,
        hasstatus  => true,
        hasrestart => true;
    }
  }

  if $facts['os']['family'] =='Debian' {
    file { '/etc/chrony/chrony.conf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('roles/chrony/debian_chrony.conf.erb');
    }
    service {
      'chrony':
        ensure     => running,
        require    => Package['chrony'],
        enable     => true,
        hasstatus  => true,
        hasrestart => true;
    }
  }
  if $facts['os']['family'] == 'FreeBSD' {
    file { '/etc/ntp.conf':
      ensure  => present,
      owner   => root,
      group   => wheel,
      mode    => '0644',
      content => template('roles/ntpd/freebsd_ntp.conf.erb');
    }
  exec {
    'ntpd_enable':
      command => '/usr/sbin/sysrc ntpd_enable="YES"',
      path    => ['/bin','/usr/bin', '/usr/sbin'],
      unless  => 'grep ^ntpd /etc/rc.conf 2>/dev/null';
    }
  exec {
    'ntpd_sync_on_start':
      command => '/usr/sbin/sysrc ntpd_sync_on_start="YES"',
      path    => ['/bin','/usr/bin', '/usr/sbin'],
      unless  => 'grep ^ntpd_sync_on_start /etc/rc.conf 2>/dev/null';
    }
    service {
      'ntpd':
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true;
      }
    }
  }
}
