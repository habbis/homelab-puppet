# Class for setup root user
class roles::server_lite::root_user {
  if $facts['os']['name'] == 'Linux' {
    user { 'root':
      ensure     => present,
      shell      => '/bin/bash',
      managehome => false,
    }

    file { '/root/.ssh':
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0700',
    }

    file { '/root/.ssh/authorized_keys2':
      ensure  => file,
      backup  => false,
      content => template('roles/sshkeys/authorized_keys.erb'),
      mode    => '0600',
    }
  }
  if $facts['os']['name'] == 'FreeBSD' {
    user { 'root':
      ensure     => present,
      shell      => '/usr/local/bin/bash',
      managehome => false,
    }

    group { 'wheel':
      ensure => present,
    }

  exec {
    'root_change_shell':
      path    => ['/bin','/usr/bin', '/usr/sbin'],
      unless  => 'grep /root:/usr/local/bin/bash /etc/passwd 2>/dev/null',
      command => 'chsh -s /usr/local/bin/bash root',
    }

    file { '/root/.ssh':
      ensure => 'directory',
      owner  => 'root',
      group  => 'wheel',
      mode   => '0700',
    }

    file { '/root/.ssh/authorized_keys2':
      ensure  => file,
      backup  => false,
      content => template('roles/sshkeys/authorized_keys.erb'),
      mode    => '0600',
    }
    file { '/root/.bash_history':
      ensure => present,
      owner  => 'root',
      group  => 'wheel',
      mode   => '0644',
    }
    file { '/root/.bash_logout':
      ensure => present,
      owner  => 'root',
      group  => 'wheel',
      mode   => '0644',
    }
  file { '/root/.bash_profile':
    ensure => present,
    owner  => 'root',
    group  => 'wheel',
    mode   => '0644',
    source => 'puppet:///modules/roles/bash_files/freebsd/.bash_profile'
    }
  file { '/root/.bashrc':
    ensure => present,
    owner  => 'root',
    group  => 'wheel',
    mode   => '0644',
    source => 'puppet:///modules/roles/bash_files/freebsd/.bashrc'
    }
  }
}
