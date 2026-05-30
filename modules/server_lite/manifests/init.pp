# basic server setup
class server_lite (
# @param search dns domains
# @param nameserver1 dns server
# @param nameserver2 dns server
# @param ntp_server set if server is ntp server true or false
  String  $search,
  String  $nameserver1,
  String  $nameserver2,
  String  $ntp_pool,
  Boolean $ntp_server
) {
  include server_lite::sshd
  include server_lite::resolv_conf
  include server_lite::bash_profile
  include server_lite::packages
  include server_lite::root_user
  include server_lite::ansible_user
  include server_lite::ntp_client
  include server_lite::hosts
  include server_lite::motd
  include server_lite::sysctl
  include server_lite::cron::puppet_restart
  include server_lite::ca_cert
}
