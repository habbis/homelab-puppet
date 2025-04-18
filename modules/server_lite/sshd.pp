# Class for installing ssh on linux servers
class server_lite::sshd {
  case $::osfamily {
    'RedHat': { include server_lite::sshd::rhel }
    'Debian': { include server_lite::sshd::debian }
    default: {
      case $::operatingsystem {
        'Debian': {
          include server_lite::sshd::debian
          $osfamily = "Debian"
        }
      }
    }
  }
}
