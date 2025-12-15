#basic setup for /etc/hosts
class server_lite::hosts {
  if $facts['kernel'] == 'Linux' {
  file {
    '/etc/hosts':
      mode    => '0644',
      owner   => root,
      group   => root,
      content => template('server_lite/etc_hosts/linux/hosts.erb');
    }
  }
}
