# Class to setup message of the day.
class server_lite::motd {
  if $facts['kernel'] == ['Linux'] {
  file {
    '/etc/motd':
      ensure  => 'present',
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template('server_lite/motd/motd.erb');
    }
  }
}
