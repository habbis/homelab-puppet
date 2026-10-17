# This is the structure of a simple plan. To learn more about writing
# Puppet plans, see the documentation: http://pup.pt/bolt-puppet-plans

# The summary sets the description of the plan that will appear
# in 'bolt plan show' output. Bolt uses puppet-strings to parse the
# summary and parameters from the plan.
# @summary A plan created with bolt plan new.
# @param targets The targets to run on.
plan homelab_puppet::test (
  TargetSpec $targets
) {
  apply($targets) {
    class { 'roles::server_lite':
      #site_content => "${site_content} from ${$trusted['certname']}",
    }
  }
}
