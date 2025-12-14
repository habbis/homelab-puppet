# Class to manage gloabal proxy setting
class server_lite::bash_profile::proxy {
  file { '/etc/profile.d/shell_alias.sh':
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///modules/server_lite/bash_profile/shell_alias.sh'
  }
}
