# Class to restart enable sshd
class server_lite::sshd::linux_start_restard_sshd inherits server_lite::sshd {
  package {
    'openssh-server':       ensure => installed;
  }

  service {
    'sshd':
      ensure     => running,
      require    => Package['openssh-server'],
      enable     => true,
      hasstatus  => true,
      hasrestart => true;
  }

  exec {
    'ssh_restart_sshd':
      command     => '/usr/bin/systemctl restart sshd',
      path        => ['/bin','/usr/bin', '/usr/sbin'],
      subscribe   => File['/etc/ssh/sshd_config'],
      refreshonly => true;
  }
}
