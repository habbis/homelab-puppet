# Class to manage gloabal proxy setting
class server_lite::bash_profile::proxy {

  file { '/etc/profile.d/proxy.sh':
     owner  => root,
     group  => root,
     mode   => '0755',
     source => 'puppet:///modules/server_lite/bash_profile/proxy.sh'
  }
}
