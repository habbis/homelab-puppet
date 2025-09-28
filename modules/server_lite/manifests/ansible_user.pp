# Class for setup ansible user
class server_lite::ansible_user {
  if $kernel == 'Linux' {
    user { 'ansible':
      ensure     => present,
      home       => '/home/ansible',
      shell      => '/bin/bash',
      managehome => true,
      gid        => 'ansible',
    }

    group { 'ansible':
      ensure => present,
    }

    file { '/home/ansible/.ssh':
      ensure => 'directory',
      owner  => 'ansible',
      group  => 'ansible',
      mode   => '0700',
    }

    file { '/home/ebbestad/.ssh/authorized_keys2':
      ensure  => file,
      backup  => false,
      content => template('server_lite/sshkeys/authorized_keys.erb'),
      mode    => '0600',
    }
  }
}
