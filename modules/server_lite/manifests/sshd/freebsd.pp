# Class to install nrpe on debian and ubuntu
class server_lite::sshd::freebsd inherits server_lite::sshd {

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
    'ssh_restart':
      command     => '/usr/sbin/service sshd restart',
      path        => ['/bin','/usr/bin', '/usr/sbin'],
      subscribe   => File['/etc/ssh/sshd_config'],
      refreshonly => true,
  }
}
