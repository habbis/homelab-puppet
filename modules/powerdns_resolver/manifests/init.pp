# setup powerdns resolver on unix servers
class powerdns_resolver {
  if $facts['os']['family'] == 'FreeBSD' {
    package {
      'powerdns-recursor':  ensure => installed;
    }
    file { '/usr/local/etc/':
      ensure  => present,
      owner   => root,
      group   => wheel,
      mode    => '0644',
      content => template('server_lite/ntpd/freebsd_ntp.conf.erb');
    }
  exec {
    'powerdns_resolver_enable':
      command => '/usr/sbin/sysrc pdns_recursor_enable="YES"',
      path    => ['/bin','/usr/bin', '/usr/sbin'],
      unless  => 'grep ^ntpd /etc/rc.conf 2>/dev/null';
    }
    service {
      'pdns_recursor':
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true;
    }
  }
}
