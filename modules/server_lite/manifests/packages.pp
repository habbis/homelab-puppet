# Class for basic packages we want on all servers
class server_lite::packages {
  package {
    'sude':          ensure => installed;
    'file':          ensure => installed;
    'wget':          ensure => installed;
    'less':          ensure => installed;
    'curl':          ensure => installed;
    'rsync':         ensure => installed;
    'git':           ensure => installed;
    'tmux':          ensure => installed;
    'ethtool':       ensure => installed;
    'python3':       ensure => installed;
    'python3-pip':   ensure => installed;
  }

  case $facts['os']['name'] {
    'Debian': { include server_lite::packages::debian }
    'RedHat': { include server_lite::packages::redhat }
    default: {
      include server_lite::sshd::rhel
    }
  }
}
