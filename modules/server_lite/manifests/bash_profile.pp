# Class for setup shell profile on unix servers
class server_lite::bash_profile {

  $disk_path = '/dev/vtbd0'
  $disk_exists = find_file($disk_path)
  $disk_path2 = '/dev/vda'
  $disk_exists2 = find_file($disk_path2)

  if !$disk_exists {
  } elsif !$disk_exists2 {
  } elsif $facts['os']['family'] != 'FreeBSD' {
  } elsif $facts['kernel'] == 'Linux' {
  include server_lite::bash_profile::proxy
  include server_lite::bash_profile::puppet
  include server_lite::bash_profile::shell_alias
  }
}
