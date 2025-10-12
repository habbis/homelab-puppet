#
# Global - All code outside a node definition gets applied to all nodes
#

#include common_packages
#include common_hosts

#
# Default - Not used, but Puppet requires at least an empty **node default**
#

node default {
# this is magic: it will include whatever classes says we should
# include, based on the value of the "classes" array
  hiera_include('classes')
}

node 'hf-t-puppet1.dc1.ncop.no' {
  # Configure puppetdb and its underlying database
  #class { 'puppetdb': }
  # Configure the Puppet master to use puppetdb
  #class { 'puppetdb::master::config': }
}
