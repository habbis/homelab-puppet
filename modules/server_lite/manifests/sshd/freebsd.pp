# Class to install nrpe on debian and ubuntu
class server_lite::sshd::freebsd inherits server_lite::sshd {

  $file_path = '/etc/ssh/ssh_host_ecdsa_key'
  $file_exists = find_file($file_path)

  if $file_exists {
  file { '/etc/ssh/ssh_host_ecdsa_key':
    ensure => 'absent',
    purge  => true,
  }

  file { '/etc/ssh/ssh_host_ecdsa_key.pub':
    ensure => 'absent',
    purge  => true,
  }

  file { '/etc/ssh/ssh_host_ed25519_key':
    ensure => 'absent',
    purge  => true,
  }

  file { '/etc/ssh/ssh_host_ed25519_key.pub':
    ensure => 'absent',
    purge  => true,
  }

  file { '/etc/ssh/ssh_host_rsa_key':
    ensure => 'absent',
    purge  => true,
  }

  file { '/etc/ssh/ssh_host_rsa_key.pub':
    ensure => 'absent',
    purge  => true,
  }

  exec {
    'ssh_disable_dsa':
      command => '/usr/sbin/sysrc sshd_dsa_enable="NO"',
      path    => ['/bin','/usr/bin', '/usr/sbin'],
  }

  exec {
    'ssh_disable_ecdsa':
      command => '/usr/sbin/sysrc sshd_ecdsa_enable="NO"',
      path    => ['/bin','/usr/bin', '/usr/sbin'],
  }

  exec {
    'ssh_enable_ed25519':
      command => '/usr/sbin/sysrc sshd_ed25519_enable="YES"',
      path    => ['/bin','/usr/bin', '/usr/sbin'],
  }

  exec {
    'ssh_enable_rsa':
      command => '/usr/sbin/sysrc sshd_rsa_enable="YES"',
      path    => ['/bin','/usr/bin', '/usr/sbin'],
  }

  exec {
    'ssh_keygen':
      command => '/usr/sbin/service sshd keygen',
      path    => ['/bin','/usr/bin', '/usr/sbin'],
  }

  exec {
    'ssh_restart_once':
      command => '/usr/sbin/service sshd restart',
      path    => ['/bin','/usr/bin', '/usr/sbin'],
  }

  }

  service {
    'sshd':
      ensure     => running,
      enable     => true,
      hasstatus  => true,
      hasrestart => true;
  }

  file { '/etc/ssh/sshd_config':
    ensure  => 'present',
    owner   => root,
    group   => wheel,
    mode    => '0600',
    content => epp('server_lite/sshd/freebsd/sshd_config.epp');
  }

  exec {
    'ssh_enable':
      command => '/usr/sbin/sysrc sshd_enable="YES"',
      path    => ['/bin','/usr/bin', '/usr/sbin'],
      unless  => 'grep ^sshd /etc/rc.conf 2>/dev/null';
  }

  exec {
    'ssh_restart_default':
      command     => '/usr/sbin/service sshd restart',
      path        => ['/bin','/usr/bin', '/usr/sbin'],
      subscribe   => File['/etc/ssh/sshd_config'],
      refreshonly => true,
  }
}
