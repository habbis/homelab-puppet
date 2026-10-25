# setup frr bgpg
class roles::frr_bgp (
  # @param ipv4 anycast address
  # @param bgp nr
  String $anycast_ipv4_address,
  String $bgp_nr
  ) {

if $facts['kernel'] == 'Linux' {

if $facts['os']['family'] =='Debian' {
  package {
    'frr':             ensure => installed;
    'frr-pythontools': ensure => installed;
    }

  file { '/etc/network/interfaces.d/anycast':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => epp('roles/frr_bgp/debian_inerface_anycast.epp');
  }

  file { '/etc/frr/frr.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => epp('roles/frr_bgp/debian_frr_conf.epp');
  }
    service {
      'unbound':
        ensure     => running,
        require    => Package['frr'],
        enable     => true,
        hasstatus  => true,
        hasrestart => true;
    }
  exec {
    'frr_systemd_restart':
      command     => 'systemctl restart frr.service',
      path        => ['/bin','/usr/bin', '/usr/sbin'],
      subscribe   => File['/etc/frr/frr.conf'],
      refreshonly => true
      }
  exec {
    'frr_anycast_networking':
      command     => 'ifup lo:0',
      path        => ['/bin','/usr/bin', '/usr/sbin'],
      subscribe   => File['/etc/network/interfaces.d/anycast'],
      refreshonly => true
      }
    }
  }
}
