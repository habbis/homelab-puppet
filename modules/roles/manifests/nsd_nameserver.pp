# setup nsd nameserver
class roles::nsd_nameserver (
# @param hmac-md5_secret
  String $hmac_md5_secret,) {

if $facts['kernel'] == 'Linux' {
  package {
    'nsd':  ensure => installed;
    }

if $facts['os']['family'] =='Debian' {
  file { '/etc/nsd/nsd.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('roles/nsd/debian_nsd.conf.erb');
  }
}
    service {
      'nsd':
        ensure     => running,
        require    => Package['nsd'],
        enable     => true,
        hasstatus  => true,
        hasrestart => true;
    }
  exec {
    'nsd_systemd_restart':
      command     => 'systemctl restart nsd.service',
      path        => ['/bin','/usr/bin', '/usr/sbin'],
      subscribe   => File['/etc/nsd/nsd.conf'],
      refreshonly => true
    }
  }
}
