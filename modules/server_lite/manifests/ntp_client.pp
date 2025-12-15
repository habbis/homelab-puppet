# Class for setting up ntp client on unix server
class server_lite::ntp_client {
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
      content => template('server_lite/chrony/rhel_chrony.conf.erb');
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
      content => template('server_lite/chrony/debian_chrony.conf.erb');
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
      content => template('server_lite/ntpd/freebsd_ntp.conf.erb');
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
