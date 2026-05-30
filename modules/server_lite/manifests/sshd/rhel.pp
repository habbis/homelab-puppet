# Class to deploy sshd config
class server_lite::sshd::rhel inherits server_lite::sshd {
if $facts['os']['release']['full']['major'] == '9' {
    file { '/etc/ssh/sshd_config':
      ensure  => 'present',
      owner   => root,
      group   => root,
      mode    => '0600',
      content => template('server_lite/sshd/rhel/el9_sshd_config.erb');
    }
    file { '/etc/ssh/sshd_config.d/50-redhat.conf':
      ensure  => 'present',
      owner   => root,
      group   => root,
      mode    => '0600',
      content => template('server_lite/sshd/rhel/el9_50-redhat.conf.erb');
    }
  }

if $facts['os']['release']['full']['major'] == '10' {
    file { '/etc/ssh/sshd_config':
      ensure  => 'present',
      owner   => root,
      group   => root,
      mode    => '0600',
      content => template('server_lite/sshd/rhel/el10_sshd_config.erb');
    }
    file { '/etc/ssh/sshd_config.d/50-redhat.conf':
      ensure  => 'present',
      owner   => root,
      group   => root,
      mode    => '0600',
      content => template('server_lite/sshd/rhel/el10_50-redhat.conf.erb');
    }
    file { '/etc/ssh/sshd_config.d/40-redhat-crypto-policies.conf':
      ensure  => 'present',
      owner   => root,
      group   => root,
      mode    => '0600',
      content => template('server_lite/sshd/rhel/el10_40-redhat-crypto-policies.conf.erb');
    }
  }

    exec {
      'ssh_restart_rhel':
        command     => '/usr/bin/systemctl restart sshd',
        refreshonly => true;
    }
  }
