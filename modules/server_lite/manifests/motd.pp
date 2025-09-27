# Class to setup message of the day.
class server_lite::motd {
  file {
    '/etc/motd':
      ensure  => 'present',
      mode    => '0444',
      owner   => 'root',
      group   => 'root',
      content => template('server_lite/motd/motd.erb');
  }
}
