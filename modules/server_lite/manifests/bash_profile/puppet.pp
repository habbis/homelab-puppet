# Class to manage puppet profile.d
class server_lite::bash_profile::puppet {
  file { '/etc/profile.d/puppet.sh':
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///modules/server_lite/bash_profile/puppet.sh',
  }
}
