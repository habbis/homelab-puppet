# Class for setup shell profile on unix servers
class server_lite::bash_profile {

  if $facts['disks'] != 'vtbd0' and $facts['kernel'] == 'FreeBSD' {
  include server_lite::bash_profile::proxy
  include server_lite::bash_profile::shell_alias
    }
  if $facts['disks'] != 'vda' and $facts['kernel'] == 'Linux' {
  include server_lite::bash_profile::proxy
  include server_lite::bash_profile::puppet
  include server_lite::bash_profile::shell_alias
  }
}
