# Class to install nrpe on debian and ubuntu
class server_lite::sshd::debian inherits server_lite::sshd {
  package {
    'openssh-server':       ensure => installed;
  }

  service {
    'ssh':
      ensure     => running,
      require    => Package['openssh-server'],
      enable     => true,
      hasstatus  => true,
      hasrestart => true;
  }

  if $facts['os']['release']['major'] == '13' {
  file { '/etc/ssh/sshd_config':
    ensure  => 'present',
    owner   => root,
    group   => root,
    mode    => '0600',
    content => template('server_lite/sshd/debian/sshd_config_deb13.erb');
    }
  } elsif $facts['os']['release']['major'] == '12' {
  file { '/etc/ssh/sshd_config':
    ensure  => 'present',
    owner   => root,
    group   => root,
    mode    => '0600',
    content => template('server_lite/sshd/debian/sshd_config_deb12.erb');
      }
    }

  exec {
    'ssh_restart':
      command     => '/usr/bin/systemctl restart sshd',
      path        => ['/bin','/usr/bin', '/usr/sbin'],
      subscribe   => File['/etc/ssh/sshd_config'],
      refreshonly => true;
  }
}
