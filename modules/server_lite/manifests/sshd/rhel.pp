# Class to deploy sshd config
class server_lite::sshd::rhel inherits server_lite::sshd {
    file { '/etc/ssh/sshd_config':
      ensure  => 'present',
      owner   => root,
      group   => root,
      mode    => '0600',
      content => template('server_lite/sshd/rhel/sshd_config.erb');
    }

    exec {
      'ssh_restart_rhel':
        command     => '/usr/bin/systemctl restart sshd',
        refreshonly => true;
    }
  }
