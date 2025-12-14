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
    # content => template('server_lite/sshd/freebsd/sshd_config.erb');
    content => epp('server_lite/sshd/freebsd/sshd_config.epp');
  }

  exec {
    'ssh_restart':
      command     => '/usr/bin/systemctl restart sshd',
      refreshonly => true;
  }
}
