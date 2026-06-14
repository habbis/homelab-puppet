# Class for basic packages we want on all servers
class roles::server_lite::packages {
  if $facts['kernel'] == 'Linux' {
  package {
    'sudo':          ensure => installed;
    'file':          ensure => installed;
    'wget':          ensure => installed;
    'less':          ensure => installed;
    'curl':          ensure => installed;
    'rsync':         ensure => installed;
    'git':           ensure => installed;
    'tmux':          ensure => installed;
    'ethtool':       ensure => installed;
    #'python3':       ensure => installed;
    #'python3-pip':   ensure => installed;
    }
  }

  case $facts['os']['family'] {
    'Debian': { include roles::server_lite::packages::debian }
    'FreeBSD': { include roles::server_lite::packages::freebsd }
    'RedHat': { include roles::server_lite::packages::redhat }
    default: {
      include roles::server_lite::sshd::debian
    }
  }
}
