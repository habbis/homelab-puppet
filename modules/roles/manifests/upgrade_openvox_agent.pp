# @summary
#   Upgrades the OpenVox agent from 8.x to 9.x on Linux (EL/Fedora/Amazon/SLES,
#   Debian/Ubuntu).
#
#   What it does, in order:
#     1. Skips nodes that are already on 9.x, the OpenVox server itself, and (by
#        default) any node whose server is not yet on 9.x.
#     2. Pins `server` in puppet.conf, because OpenVox 9 no longer falls back to
#        the hostname `puppet` when `server` is unset.
#     3. Installs the openvox9-release repo package and removes openvox8-release.
#     4. Upgrades the openvox-agent package (last, so the Ruby 3.2 -> 4.0 swap
#        happens at the end of the run).
#     5. Schedules a delayed restart of the puppet service via systemd-run, so
#        the running agent isn't killed mid-run.
#
#   Requires puppetlabs-inifile (for ini_setting).
#
# @param version
#   Package version for openvox-agent. 'latest' is the safest default because
#   apt needs the full Debian version string (e.g. '9.1.0-1+ubuntu24.04').
#   On yum/dnf/zypper a bare '9.1.0' works.
# @param server
#   Value to pin as `server` in puppet.conf [main]. Defaults to the name of the
#   server compiling the catalog.
# @param manage_server_setting
#   Set false if agents use server_list, SRV records, or otherwise don't need
#   `server` pinned.
# @param require_server_9
#   Only upgrade when the compiling server reports version >= 9.0.0.
#   Agents should never be newer than their server.
# @param yum_base / apt_base
#   Base URLs for the release packages (override if you mirror them).
# @param restart_service
#   Schedule a restart of puppet.service after the upgrade.
# @param restart_delay
#   Seconds to wait before that restart, giving the current run time to finish
#   and submit its report.
#
# @example Hiera
#   classes:
#     - openvox_upgrade
#   openvox_upgrade::version: 'latest'
#
class roles::upgrade_openvox_agent (
  String[1]  $version               = 'latest',
  String[1]  $server                = $server_facts['servername'],
  Boolean    $manage_server_setting = true,
  Boolean    $require_server_9      = true,
  String[1]  $yum_base              = 'https://yum.voxpupuli.org',
  String[1]  $apt_base              = 'https://apt.voxpupuli.org',
  Boolean    $restart_service       = true,
  Integer[1] $restart_delay         = 60,
) {
  $current_version = $facts['aio_agent_version']
  $server_version  = $server_facts['serverversion']

  # --- Guards ---------------------------------------------------------------
  if $current_version =~ Undef {
    notify { 'openvox_upgrade: aio_agent_version fact missing, skipping': }
    return()
  }

  if versioncmp($current_version, '9.0.0') >= 0 {
    # Already on 9.x – nothing to do.
    return()
  }

  if $trusted['certname'] == $server_facts['servername'] {
    # openvox-server 8 requires openvox-agent < 9. Upgrading only the agent on
    # the server host would conflict with (or remove) openvox-server.
    # Upgrade agent + server + openvoxdb together by hand on server hosts.
    notify { 'openvox_upgrade: skipping server host, upgrade it manually as a set': }
    return()
  }

  if $require_server_9 and versioncmp(String($server_version), '9.0.0') < 0 {
    notify { "openvox_upgrade: server is ${server_version}, waiting for 9.x before upgrading agent": }
    return()
  }

  if $facts['kernel'] != 'Linux' {
    notify { "openvox_upgrade: ${facts['kernel']} not handled by this class": }
    return()
  }

  # --- 1. Pin `server` in puppet.conf ----------------------------------------
  if $manage_server_setting {
    ini_setting { 'openvox_upgrade server':
      ensure  => present,
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      section => 'main',
      setting => 'server',
      value   => $server,
      before  => Package['openvox-agent'],
    }
  }

  # --- 2. Repositories -------------------------------------------------------
  $os_name  = downcase($facts['os']['name'])
  $os_major = $facts['os']['release']['major']

  case $facts['os']['family'] {
    'RedHat', 'Suse': {
      $dist = $facts['os']['family'] ? {
        'Suse'  => 'sles',
        default => $os_name ? {
          'fedora' => 'fedora',
          'amazon' => 'amazon',
          default  => 'el',
        },
      }
      $release_url = "${yum_base}/openvox9-release-${dist}-${os_major}.noarch.rpm"

      package { 'openvox9-release':
        ensure   => installed,
        provider => 'rpm',
        source   => $release_url,
      }

      package { 'openvox8-release':
        ensure  => absent,
        require => Package['openvox9-release'],
        before  => Package['openvox-agent'],
      }

      $repo_ready = Package['openvox9-release']
    }

    'Debian': {
      $codename = $os_name ? {
        'ubuntu' => "ubuntu${facts['os']['release']['full']}",
        default  => "debian${os_major}",
      }
      $deb_path = '/var/tmp/openvox9-release.deb'

      file { '/etc/apt/sources.list.d/openvox8-release.list':
        ensure => absent,
      }

      file { $deb_path:
        ensure => file,
        source => "${apt_base}/openvox9-release-${codename}.deb",
        mode   => '0644',
      }


      package { 'openvox9-release':
        ensure   => installed,
        provider => 'dpkg',
        source   => $deb_path,
        require  => File[$deb_path],
      }

      package { 'openvox8-release':
        ensure  => purged,
        require => Package['openvox9-release'],
        notify  => Exec['openvox_upgrade apt update'],
      }

      exec { 'openvox_upgrade apt update':
        command     => '/usr/bin/apt-get update',
        refreshonly => true,
        subscribe   => Package['openvox9-release'],
      }

      $repo_ready = Exec['openvox_upgrade apt update']
    }

    default: {
      notify { "openvox_upgrade: os family ${facts['os']['family']} not supported": }
      return()
    }
  }

  # --- 3. Upgrade the agent --------------------------------------------------
  package { 'openvox-agent':
    ensure  => $version,
    require => $repo_ready,
  }

  # --- 4. Delayed restart ----------------------------------------------------
  # Restarting puppet.service directly would kill this run before it reports.
  if $restart_service {
    exec { 'openvox_upgrade schedule restart':
      command     => "/usr/bin/systemd-run --on-active=${restart_delay} /bin/systemctl try-restart puppet.service",
      refreshonly => true,
      subscribe   => Package['openvox-agent'],
    }
  }
}
