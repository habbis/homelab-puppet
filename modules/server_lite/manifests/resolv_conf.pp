# Class to setuo resolve.conf and disable systemd-resolved.
class server_lite::resolv_conf {
  exec {
    'disable_systemd_resolv':
      path    => ['/bin'],
      command => 'systemctl disable --now systemd-resolved.service',
  }

  file { '/etc/resolv.conf':
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => 'puppet:///modules/puppet_homelab/resolv_conf/resolv.conf'
  }
}
