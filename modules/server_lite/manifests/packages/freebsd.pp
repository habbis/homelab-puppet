#Class for freebsd specific packages
class server_lite::packages::freebsd {
  package {
    'pwgen':     ensure => installed;
    'virt-what': ensure => installed;
    'tldr': ensure => installed;
    'netcat': ensure => installed;
    'psmisc': ensure => installed;
    'bash': ensure => installed;
    'bash-completion': ensure => installed;
    'sudo': ensure => installed;
    'tmux': ensure => installed;
    'python-3.11_3,2': ensure => installed;
    'py311-pip': ensure => installed;H
  }
  if ! defined(Package['vim']) {
    package {
      'vim':       ensure => installed;
    }
  }

}
