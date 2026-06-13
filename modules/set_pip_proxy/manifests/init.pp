# set global pip config 
class set_pip_proxy (
# @param proxy_server
  String  $proxy_server,) {

if $facts['kernel'] == 'Linux' {
  package {
    'chrony':  ensure => installed;
    }

  file { '/etc/pip.conf':
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('server_lite/pip_config/pip.conf.erb');
  }
}

if $facts['os']['family'] == 'FreeBSD' {
  file { '/etc/pip.conf':
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('server_lite/pip_config/pip.conf.erb');
    }
  }
}
