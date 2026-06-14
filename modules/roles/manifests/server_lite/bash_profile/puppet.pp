# Class to manage puppet profile.d
class roles::server_lite::bash_profile::puppet {
  file { '/etc/profile.d/puppet.sh':
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///modules/roles/bash_profile/puppet.sh',
  }
}
