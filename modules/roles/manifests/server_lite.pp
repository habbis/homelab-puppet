# basic server setup
class roles::server_lite (
# @param search dns domains
# @param nameserver1 dns server
# @param nameserver2 dns server
# @param ntp_pool ntp pool for server
# @param ntp_server set if server is ntp server true or false
# @param http_proxy server
# @param no_proxy domain name
  String  $search,
  String  $nameserver1,
  String  $nameserver2,
  String  $ntp_pool,
  String  $proxy_server,
  String  $no_proxy,
  Boolean $ntp_server,
  Boolean $dns_resolver,
) {
  include roles::server_lite::sshd
  include roles::server_lite::resolv_conf
  include roles::server_lite::bash_profile
  include roles::server_lite::packages
  include roles::server_lite::root_user
  include roles::server_lite::ansible_user
  include roles::server_lite::ntp_client
  include roles::server_lite::hosts
  include roles::server_lite::motd
  include roles::server_lite::sysctl
  include roles::server_lite::cron::puppet_restart
  include roles::server_lite::ca_cert
}
