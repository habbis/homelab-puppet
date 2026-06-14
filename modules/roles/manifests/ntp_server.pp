# setup ntp server
class roles::ntp_server (
# @param ntp_pool ntp server
  String  $ntp_server,) {

if $facts['kernel'] == 'Linux' {
  package {
    'chrony':  ensure => installed;
    }

if  $facts['os']['family'] =='RedHat' {
  file { '/etc/chrony.conf':
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('server_lite/chrony/rhel_chrony.conf.erb');
  }
}
if $facts['os']['family'] =='Debian' {
  file { '/etc/chrony/chrony.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('ntp_server/chrony/debian_chrony.conf.erb');
  }
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
      content => template('ntp_server/ntpd/freebsd_ntp.conf.erb');
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
