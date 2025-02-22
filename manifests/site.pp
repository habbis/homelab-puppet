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


}

node 'hf-puppet2*' {


  class { "homelab-puppet::server_lite": }

  # Configure puppetdb and its underlying database
  class { 'puppetdb': }

  # Configure the Puppet master to use puppetdb
  class { 'puppetdb::master::config': }


}


#
# Use Hiera to classify nodes
#

#hiera_include('classes')
