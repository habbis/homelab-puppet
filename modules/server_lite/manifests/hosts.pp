#basic setup for /etc/hosts
class server_lite::hosts {

  $disk_path = '/dev/vtbd0'
  $disk_exists = find_file($disk_path)
  $disk_path2 = '/dev/vda'
  $disk_exists2 = find_file($disk_path2)


  if !$disk_exists {
  } elsif !$disk_exists2 {
  } elsif $facts['kernel'] == 'Linux' {
  file {
    '/etc/hosts':
      mode    => '0644',
      owner   => root,
      group   => root,
      content => template('server_lite/etc_hosts/linux/hosts.erb');
    }
  } elsif $facts['os']['family'] != 'FreeBSD' {
  file {
    '/etc/hosts':
      mode    => '0644',
      owner   => root,
      group   => root,
      content => template('server_lite/etc_hosts/freebsd/hosts.erb');
    }
  }
}
