# Class for installing ssh on linux servers
class server_lite::sshd {
  if $facts['kernel'] == 'Linux' {
  include server_lite::sshd::linux_install_sshd
}

if $facts['os']['family'] == 'RedHat' {
  include server_lite::sshd::rhel

}

if $facts['os']['family'] == 'Debian' {
  include server_lite::sshd::debian

}

if $facts['os']['family'] == 'FreeBSD' {
  include server_lite::sshd::freebsd

}

  if $facts['kernel'] == 'Linux' {
  include server_lite::sshd::linux_start_sshd
  }
}
