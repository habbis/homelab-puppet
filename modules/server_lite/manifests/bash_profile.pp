# Class for setup shell profile on unix servers
class server_lite::bash_profile {
  if $facts['kernel'] == 'Linux' {
  include server_lite::bash_profile::proxy
  include server_lite::bash_profile::puppet
  include server_lite::bash_profile::shell_alias
  }
}
