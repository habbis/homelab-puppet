# Class for installing ssh on linux servers
class server_lite::sshd {
  case $facts['os']['name'] {
    'RedHat': { include server_lite::sshd::rhel }
    'Debian': { include server_lite::sshd::debian }
    default: {
      include server_lite::sshd::rhel
    }
  }
}
