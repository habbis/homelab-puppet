# basic server setup
class server_lite {
  include server_lite::sshd
  include server_lite::resolv_conf
  include server_lite::bash_profile
  include server_lite::packages
  include server_lite::ansible_user
  include server_lite::hosts
  include server_lite::motd
  #include server_lite::cron::puppet_restart
}
