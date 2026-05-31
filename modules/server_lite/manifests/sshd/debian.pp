# Class to deploy sshd config
class server_lite::sshd::debian inherits server_lite::sshd {
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
    } elsif $facts['os']['release']['major'] == '11' {
  file { '/etc/ssh/sshd_config':
    ensure  => 'present',
    owner   => root,
    group   => root,
    mode    => '0600',
    content => template('server_lite/sshd/debian/sshd_config_deb11.erb');
      }
    }
  exec {
    'ssh_restart_sshd_debian':
      command     => '/usr/bin/systemctl restart sshd',
      path        => ['/bin','/usr/bin', '/usr/sbin'],
      refreshonly => true;
  }
}
