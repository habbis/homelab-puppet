# install rsync
class roles::install_rsync {
  # Ensure rsync is installed
  package { 'rsync':
    ensure => installed,
  }
}
