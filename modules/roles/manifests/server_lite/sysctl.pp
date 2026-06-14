# Class for setting sysctl unix server
class roles::server_lite::sysctl {
  if $facts['os']['family'] == 'FreeBSD' {
    file { '/etc/sysctl.conf':
      ensure  => present,
      owner   => root,
      group   => wheel,
      mode    => '0644',
      content => epp('roles/sysctl/freebsd/sysctl.conf.epp'),
    }
  }
}
