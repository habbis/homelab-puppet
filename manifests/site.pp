

node default {
# Global - All code outside a node definition gets applied to all nodes
#
#
# Global - All code outside a node definition gets applied to all nodes
#

#include common_packages
#include common_hosts

#
# Default - Not used, but Puppet requires at least an empty **node default**
#

node default {


  #class { "homelab-puppet::server_lite": }
  hiera_include('classe')
  #lookup('classes').include


}

node 'hf-puppet1' {


  #class { "homelab-puppet::server_lite": }

  # Configure puppetdb and its underlying database
  #class { 'puppetdb': }

  # Configure the Puppet master to use puppetdb
  #class { 'puppetdb::master::config': }


}


node 'hf-puppet-client1.dc1.ncop.no' {
  include server_lite

  #class { "homelab-puppet::server_lite": }
}


