# Class to restart enable sshd
class server_lite::sshd::linux_start_sshd inherits server_lite::sshd {
  service {
    'sshd':
      ensure     => running,
      require    => Package['openssh-server'],
      enable     => true,
      hasstatus  => true,
      hasrestart => true;
  }
}
