# Class to manage gloabal proxy setting
class server_lite::bash_profile::proxy {
if  $facts['kernel'] == 'Linux' {
  file { '/etc/profile.d/proxy.sh':
    owner   => root,
    group   => root,
    mode    => '0755',
    content => epp('server_lite/bash_profile/proxy.sh.epp')
    }
  }
if  $facts['os']['family'] =='FreeBSD' {
  file { '/etc/profile.d/proxy.sh':
    ensure  => present,
    owner   => root,
    group   => wheel,
    mode    => '0755',
    content => epp('server_lite/bash_profile/proxy.sh.epp'),
      }
    }
  }
