# Class to install sshd
class server_lite::sshd::linux_install_sshd inherits server_lite::sshd {
  package {
    'openssh-server':       ensure => installed;
  }
}
