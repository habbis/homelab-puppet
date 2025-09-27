class server_lite::cron::puppet_restart {
  unless $::osfamily == 'windows' {
    cron { 'puppet-restart':
      ensure      => 'present',
      environment => 'PATH=/bin:/sbin:/usr/bin:/usr/sbin',
      command     => 'systemctl restart puppet > /dev/null',
      user        => 'root',
      hour        => '22',
      minute      => fqdn_rand(59);
    }
  }
}
