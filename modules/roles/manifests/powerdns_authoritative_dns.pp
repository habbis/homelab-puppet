# setup powerdns authoritative dns
class roles::powerdns_authoritative_dns (
# @param pdns_mysql_password
# @param pdns_api_token
  String $pdns_mysql_password,
  String $pdns_api_token,) {

if $facts['os']['family'] =='Debian' {
  package {
    'pdns-backend-bind':  ensure => installed;
    'pdns-backend-mysql': ensure => installed;
    'pdns-server':        ensure => installed;
    'pdns-tools':         ensure => installed;
  }

  file { '/etc/powerdns/pdns.conf':
    ensure  => present,
    owner   => root,
    group   => pdns,
    mode    => '0640',
    content => template('roles/powerdns/debian_pdns.conf.erb');
  }

  file { '/etc/powerdns/pdns.d/pdns.remote.gmysql.conf':
    ensure  => present,
    owner   => root,
    group   => pdns,
    mode    => '0640',
    content => template('roles/powerdns/debian_pdns_remote_mysql_conf.erb');
  }
    service {
      'pdns':
        ensure     => running,
        require    => Package['pdns-server'],
        enable     => true,
        hasstatus  => true,
        hasrestart => true;
    }
  exec {
    'pdns_systemd_restart':
      command     => 'systemctl restart pdns.service',
      path        => ['/bin','/usr/bin', '/usr/sbin'],
      subscribe   => File['/etc/powerdns/pdns.conf'],
      refreshonly => true
    }
  }
}
