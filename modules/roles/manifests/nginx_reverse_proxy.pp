# setup nginx reverese proxy
class roles::nginx_reverse_proxy (
# @param keepalived_master
  Boolean $keepalived_master,) {

if $facts['kernel'] == 'Linux' {
  package {
    'nginx':  ensure => installed;
    'keepalived':  ensure => installed;
    }

if $facts['os']['family'] =='Debian' {
  file { '/etc/nginx/nginx.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('nginx_reverse_proxy/nginx/debian_nginx.conf.erb');
  }
  exec {
    'test_nginx_config':
      command     => '/usr/sbin/nginx -t',
      path        => ['/bin','/usr/bin', '/usr/sbin'],
      subscribe   => File['/etc/nginx/nginx.conf'],
      refreshonly => true,
  }
  file { '/etc/nginx/sites-enabled/reverse_proxy':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('nginx_reverse_proxy/nginx/debian_reverse_proxy.erb');
  }
  exec {
    'test_nginx_proxy_config':
      command     => '/usr/sbin/nginx -t',
      path        => ['/bin','/usr/bin', '/usr/sbin'],
      subscribe   => File['/etc/nginx/sites-enabled/reverse_proxy'],
      refreshonly => true,
  }
    service {
      'nginx':
        ensure     => running,
        require    => Package['nginx'],
        enable     => true,
        hasstatus  => true,
        hasrestart => true;
    }
  exec {
    'nginx_restart_default':
      command     => 'service nginx reload',
      path        => ['/bin','/usr/bin', '/usr/sbin'],
      subscribe   => File['/etc/nginx/sites-enabled/reverse_proxy'],
      refreshonly => true,
    }
if $keepalived_master == true {
  file { '/etc/keepalived/keepalived.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('nginx_reverse_proxy/keepalived/debian_master_keepalived.conf.erb');
    }
  }
if $keepalived_master == false {
  file { '/etc/keepalived/keepalived.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('nginx_reverse_proxy/keepalived/debian_backup_keepalived.conf.erb');
    }
  }
  exec {
    'test_keepalived_config':
      command     => '/usr/sbin/keepalived -t',
      path        => ['/bin','/usr/bin', '/usr/sbin'],
      subscribe   => File['/etc/keepalived/keepalived.conf'],
      refreshonly => true,
    }
    service {
      'keepalived':
        ensure     => running,
        require    => Package['keepalived'],
        enable     => true,
        hasstatus  => true,
        hasrestart => true;
    }
  exec {
    'keepalived_restart_default':
      command     => 'service keepalived restart',
      path        => ['/bin','/usr/bin', '/usr/sbin'],
      subscribe   => File['/etc/keepalived/keepalived.conf'],
      refreshonly => true,
      }
    }
  }
}
