# create  ssh key for a user
class roles::create_ssk_key (
  # @param username to place ssh key
  $ssh_key_username = $roles::create_ssk_key::ssh_key_username,) {

  if $ssh_key_username == 'root' {
    exec { 'generate_ssh_key':
      command => '/usr/bin/ssh-keygen -t ed25519  /root/.ssh/id_ed25519 -N "" -C "root@host"',
      user    => root,
      path    => ['/usr/bin/', '/bin/'],
      creates => '/root/.ssh/id_ed25519',
    }
  } else {

    file { '/home/ansible/.ssh':
      ensure => 'directory',
      owner  => '$ssh_key_username',
      group  => '$ssh_key_username',
      mode   => '0700',
    }

    exec { 'generate_ssh_key':
      command => '/usr/bin/ssh-keygen -t ed25519  /home/$ssh_key_username/.ssh/id_rsa -N "" -C "$ssh_key_username@host"',
      user    => '$ssh_key_username',
      path    => ['/usr/bin/', '/bin/'],
      creates => '/home/$ssh_key_username/.ssh/id_ed25519',
    }
  }
}
