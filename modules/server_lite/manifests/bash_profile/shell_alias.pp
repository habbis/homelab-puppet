# Class to manage gloabal shell alias setting
class server_lite::bash_profile::shell_alias {
if  $facts['kernel'] == 'Linux' {
  file { '/etc/profile.d/shell_alias.sh':
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///modules/server_lite/bash_profile/shell_alias.sh'
    }
  }
if  $facts['kernel'] == 'FreeBSD' {
  file { '/etc/profile.d/shell_alias.sh':
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///modules/server_lite/bash_profile/shell_alias.sh'
    }
  }
}
