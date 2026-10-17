# setup unbound resolver
class roles::unbound_resolver {

if $facts['kernel'] == 'Linux' {
  package {
    'unbound':  ensure => installed;
    }

if $facts['os']['family'] =='Debian' {
  file { '/etc/unbound/unbound.conf.d/local.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('roles/unbound/debian_local.conf.erb');
  }
}
    service {
      'unbound':
        ensure     => running,
        require    => Package['unbound'],
        enable     => true,
        hasstatus  => true,
        hasrestart => true;
    }
  exec {
    'unbound_systemd_restart':
      command     => 'systemctl restart unbound.service',
      path        => ['/bin','/usr/bin', '/usr/sbin'],
      subscribe   => File['/etc/unbound/unbound.conf.d/local.conf'],
      refreshonly => true
    }
  }
}
