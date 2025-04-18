# Class for installing ssh on linux servers
class server_lite::bash_profile {
    include server_lite::bash_profile::proxy
    include server_lite::bash_profile::puppet
}
