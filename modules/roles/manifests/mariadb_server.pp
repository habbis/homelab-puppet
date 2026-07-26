# setup mariadb server internal repo unix servers
class roles::mariadb_server (
# @param bind_address
# @param bind_port
# @param type_db_server
# @param secondary_server_id
  String  $bind_address,
  Integer $bind_port,
  Integer $secondary_server_id,
  Variant[String, Enum['main', 'secondary']]  $type_db_server,) {

if $facts['kernel'] == 'Linux' {
  package {
    'mariadb-server':  ensure => installed;
    }

if $facts['os']['family'] == 'Debian' {
  file { '/etc/mysql/mariadb.conf.d/50-server.cnf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => epp('roles/mariadb/debian_mariadb_50-server.cnf.epp');
      }
    }

    service {
      'mariadb':
        ensure     => running,
        require    => Package['mariadb-server'],
        enable     => true,
        hasstatus  => true,
        hasrestart => true;
    }
  }
}
