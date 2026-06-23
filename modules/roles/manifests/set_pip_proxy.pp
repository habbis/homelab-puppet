# set global pip config
class roles::set_pip_proxy (
# @param proxy_server
  String  $proxy_server,) {

if $facts['kernel'] == 'Linux' {
  file { '/etc/pip.conf':
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('roles/pip_config/pip.conf.erb');
  }
}

if $facts['os']['family'] == 'FreeBSD' {
  file { '/etc/pip.conf':
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('roles/pip_config/pip.conf.erb');
    }
  }
}
