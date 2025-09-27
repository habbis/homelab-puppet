# Class to install nrpe on debian and ubuntu
class server_lite::sshd::debian inherits puppet_homelab::sshd {

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

    file { '/etc/ssh/sshd_config':
      owner  => root,
      group  => root,
      mode   => '0644',
      ensure => 'present',
      content => template('server_lite/sshd/debian/sshd_config.erb');
    }

    exec {
      'ssh_restart':
        command     => '/usr/bin/systemctl restart sshd',
        refreshonly => true;
    }

}
