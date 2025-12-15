# basic server setup
class server_lite (
# @param search dns domains
# @param nameserver1 dns server
# @param nameserver2 dns server
  String  $search,
  String  $nameserver1,
  String  $nameserver2,
  String  $ntp_pool,
) {
  contain server_lite::sshd
  contain server_lite::resolv_conf
  contain server_lite::bash_profile
  contain server_lite::packages
  contain server_lite::root_user
  contain server_lite::ansible_user
  contain server_lite::ntp_client
  contain server_lite::hosts
  contain server_lite::motd
  contain server_lite::sysctl
  contain server_lite::cron::puppet_restart
}
