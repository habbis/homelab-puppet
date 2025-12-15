# Class to setup resolve.conf and disable systemd-resolved on linux servers.
class server_lite::resolv_conf {

  $disk_path = '/dev/vtbd0'
  $disk_exists = find_file($disk_path)
  $disk_path2 = '/dev/vda'
  $disk_exists = find_file($disk_path2)

  if $facts['kernel'] == 'Linux' {
  service {
    'systemd-resolved':
      ensure    => stopped,
      enable    => false,
      hasstatus => true,
    }
  }
  if !$disk_exists {
  } elsif !$disk_exists {
  } elsif $facts['os']['family'] != 'FreeBSD' {
  file { '/etc/resolv.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => epp('server_lite/resolv_conf/resolv.conf.epp'),
    }
  } elsif $facts['kernel'] == 'Linux' {
  file { '/etc/resolv.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => epp('server_lite/resolv_conf/resolv.conf.epp'),
    }
  }
}
