# Class to restart enable sshd
class roles::server_lite::sshd::linux_start_sshd inherits roles::server_lite::sshd {
  service {
    'sshd':
      ensure     => running,
      require    => Package['openssh-server'],
      enable     => true,
      hasstatus  => true,
      hasrestart => true;
  }
}
