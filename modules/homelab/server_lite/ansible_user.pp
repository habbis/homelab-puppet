class server_lite::ansible_user {

  user { 'ansible':
    ensure      => present,
    home        => '/home/ansible',
    shell       => '/bin/bash',
    managehome  => true,
    gid         => 'ansible',
  }

  group { 'ansible':
    ensure  => present,
  }
}
