#basic setup for /etc/hosts
class server_lite::hosts {

  if $facts['disks'] != 'vtbd0' and $facts['kernel'] == 'FreeBSD' {
  file { '/etc/hosts':
    ensure  => present,
    owner   => root,
    group   => wheel,
    mode    => '0644',
    content => template('server_lite/etc_hosts/freebsd/hosts.erb'),
      }
    }
  if $facts['disks'] != 'vda' and $facts['kernel'] == 'Linux' {
  file { '/etc/hosts':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('server_lite/etc_hosts/linux/hosts.erb'),
    }
  }
}
