# Class to install nrpe on debian and ubuntu
class server_lite::sshd::rhel inherits server_lite::sshd {
    service {
      'sshd':
        ensure     => running,
        require    => Package['openssh-server'],
        enable     => true,
        hasstatus  => true,
        hasrestart => true;
    }

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
