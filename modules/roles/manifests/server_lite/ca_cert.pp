# Class for setting up ca cert on unix server
class roles::server_lite::ca_cert {
  if  $facts['os']['family'] =='RedHat' {
    file { '/etc/pki/ca-trust/source/anchors/habbfarm.crt':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('roles/ca_cert/habbfarm.crt.erb');
    }
  exec {
    'ca_enable':
      command => 'update-ca-trust',
      path    => ['/bin','/usr/bin', '/usr/sbin'],
      unless  => 'ls -al /etc/pki/ca-trust/source/anchors/habbfarm.crt 2>/dev/null';
    }
  }

  if $facts['os']['family'] =='Debian' {
    file { '/usr/local/share/ca-certificates/habbfarm.crt':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('roles/ca_cert/habbfarm.crt.erb');
    }
  exec {
    'ca_enable':
      command => '/usr/sbin/update-ca-certificates',
      path    => ['/bin','/usr/bin', '/usr/sbin'],
      unless  => 'ls -al /usr/local/share/ca-certificates//habbfarm.crt 2>/dev/null';
    }
  }
  if $facts['os']['family'] == 'FreeBSD' {
    file { '/usr/local/etc/ssl':
      ensure => 'directory',
      owner  => 'root',
      group  => 'wheel',
      mode   => '0644',
    }
    file { '/usr/local/etc/ssl/certs':
      ensure => 'directory',
      owner  => 'root',
      group  => 'wheel',
      mode   => '0644',
    }
    file { '/usr/local/share/certs/habbfarm.crt':
      ensure  => present,
      owner   => root,
      group   => wheel,
      mode    => '0644',
      content => template('roles/ca_cert/habbfarm.crt.erb');
    }
  exec {
    'ca_enable':
      command => '/usr/sbin/certctl rehash',
      path    => ['/bin','/usr/bin', '/usr/sbin'],
      unless  => 'ls -al /usr/local/share/certs/habbfarm.crt 2>/dev/null';
    }
  }
}
