# Class for installing ssh on linux servers
class server_lite::sshd {
  if $facts['kernel'] == 'Linux' {
  include server_lite::sshd::linux_install_sshd
  }

  case $facts['os']['family'] {
    'RedHat': { include server_lite::sshd::rhel }
    'Debian': { include server_lite::sshd::debian }
    'FreeBSD': { include server_lite::sshd::freebsd }
    default: {
      include server_lite::sshd::rhel
    }
  }

  if $facts['kernel'] == 'Linux' {
  include server_lite::sshd::linux_start_sshd
  }
}
