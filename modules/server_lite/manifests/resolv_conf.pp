# Class to setup resolve.conf and disable systemd-resolved on linux servers.
class server_lite::resolv_conf {
 if $facts['kernel'] == 'Linux' {
  service {
    'systemd-resolved':
      ensure    => stopped,
      enable    => false,
      hasstatus => true,
   }
  }
 unless $partitions['partitions']['vtbd0p1'] {
  file { '/etc/resolv.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => epp('server_lite/resolv_conf/resolv.conf.epp'),
    }
  }
}
