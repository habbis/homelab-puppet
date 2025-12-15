# Class to manage gloabal shell alias setting
class server_lite::bash_profile::shell_alias {
  file { '/etc/profile.d/proxy.sh':
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///modules/server_lite/bash_profile/proxy.sh'
  }
}
