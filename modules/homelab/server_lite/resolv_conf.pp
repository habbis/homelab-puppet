class server_lite::resolv_conf {


exec {
    'disable_esystemd_resolv':
     path        => ['/bin'],
     command     => 'systemctl disable --now systemd-resolved.service',
  }


file { '/etc/resolv.conf':
     owner  => root,
     group  => root,
     mode   => '0644',
     ensure => present,
     source => 'puppet:///modules/puppet_homelab/resolv_conf/resolv.conf'
  }
}
