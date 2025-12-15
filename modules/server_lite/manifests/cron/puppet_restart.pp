# Class to restart puppet agent.
class server_lite::cron::puppet_restart {
  if $facts['kernel'] == 'Linux' {
    cron { 'puppet-restart':
      ensure      => 'present',
      environment => 'PATH=/bin:/sbin:/usr/bin:/usr/sbin',
      command     => 'systemctl restart puppet > /dev/null 2>&1',
      user        => 'root',
      hour        => '22',
      minute      => fqdn_rand(59);
      }
  }

  if $facts['kernel'] == 'FreeBSD' {
    cron { 'puppet-restart':
      ensure      => 'present',
      environment => 'PATH=/bin:/sbin:/usr/bin:/usr/sbin',
      command     => 'service puppet restart > /dev/null 2>&1',
      user        => 'root',
      hour        => '22',
      minute      => fqdn_rand(59);
    }
  }
}
