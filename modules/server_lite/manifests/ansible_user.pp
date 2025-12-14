# Class for setup ansible user
class server_lite::ansible_user {
  if $facts['os'] == 'Linux' {
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

    file { '/home/ansible/.ssh/authorized_keys2':
      ensure  => file,
      backup  => false,
      content => template('server_lite/sshkeys/authorized_keys.erb'),
      mode    => '0600',
    }
  }
  if $facts['os'] == 'FreeBSD' {
    user { 'ansible':
      ensure     => present,
      home       => '/home/ansible',
      shell      => '/usr/local/bin/bash',
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

    file { '/home/ansible/.ssh/authorized_keys2':
      ensure  => file,
      backup  => false,
      content => template('server_lite/sshkeys/authorized_keys.erb'),
      mode    => '0600',
    }
    file { '/home/ansible/.bash_history':
      ensure => present,
      owner  => 'ansible',
      group  => 'ansible',
      mode   => '0644',
    }
    file { '/home/ansible/.bash_logout':
      ensure => present,
      owner  => 'ansible',
      group  => 'ansible',
      mode   => '0644',
    }
  file { '/home/ansible/.bash_profile':
    ensure => present,
    owner  => 'ansible',
    group  => 'ansible',
    mode   => '0644',
    source => 'puppet:///modules/server_lite/bash_files/freebsd/.bash_profile'
    }
  file { '/home/ansible/.bashrc':
    ensure => present,
    owner  => 'ansible',
    group  => 'ansible',
    mode   => '0644',
    source => 'puppet:///modules/server_lite/bash_files/freebsd/.bashrc'
    }
  }
}
