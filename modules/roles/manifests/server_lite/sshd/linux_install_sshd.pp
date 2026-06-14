# Class to install sshd
class roles::server_lite::sshd::linux_install_sshd inherits roles::server_lite::sshd {
  package {
    'openssh-server':       ensure => installed;
  }
}
