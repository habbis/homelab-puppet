# Class to install nrpe on debian and ubuntu
class server_lite::sshd::rhel inherits puppet_homelab::sshd {

 if $facts['os']['family'] =='RedHat' {
    package {
      'openssh-server':       ensure => installed;
    }

    service {
      'sshd':
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
      content => template('server_lite/sshd/rhel/sshd_config.erb');
    }

    exec {
      'ssh_restart':
        command     => '/usr/bin/systemctl restart sshd',
        refreshonly => true;
    }

}
