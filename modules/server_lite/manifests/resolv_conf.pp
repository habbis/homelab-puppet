# Class to setuo resolve.conf and disable systemd-resolved.
class server_lite::resolv_conf {
  service {
    'systemd-resolved':
      ensure    => stopped,
      enable    => false,
      hasstatus => true,
  }

  file { '/etc/resolv.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => epp('server_lite/resolv_conf/resolv.conf.epp'),
  }
}
