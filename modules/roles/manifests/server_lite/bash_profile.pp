# Class for setup shell profile on unix servers
class roles::server_lite::bash_profile {

  if $facts['disks'] != 'vtbd0' and $facts['kernel'] == 'FreeBSD' {
  include roles::server_lite::bash_profile::proxy
  include roles::server_lite::bash_profile::shell_alias
    }
  if $facts['disks'] != 'vda' and $facts['kernel'] == 'Linux' {
  include roles::server_lite::bash_profile::proxy
  include roles::server_lite::bash_profile::puppet
  include roles::server_lite::bash_profile::shell_alias
  }
}
