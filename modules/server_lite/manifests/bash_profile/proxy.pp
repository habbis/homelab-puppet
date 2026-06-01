# Class to manage gloabal proxy setting
class server_lite::bash_profile::proxy {
if  $facts['set_proxy_server'] == true {
if  $facts['kernel'] == 'Linux' {
  file { '/etc/profile.d/proxy.sh':
    owner  => root,
    group  => root,
    mode   => '0755',
    source => epp('server_lite/templates/bash_profile/proxy.sh.epp')
    }
  }
if  $facts['os']['family'] =='FreeBSD' {
  file { '/etc/profile.d/proxy.sh':
    ensure  => present,
    owner   => root,
    group   => wheel,
    mode    => '0755',
    content => epp('server_lite/templates/bash_profile/proxy.sh.epp'),
      }
    }
  }
}
