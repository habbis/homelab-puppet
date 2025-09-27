# Class for installing squid on linux server
class server_lite::ntp_client {


  package {
    'chrony':  ensure => installed;
    }

  case $::osfamily {
    'redhat': {
  file { '/etc/chrony.conf':
     owner  => root,
     group  => root,
     mode   => '0644',
     ensure => present,
     content => template('server_lite/chrony/rhel_chrony.conf.erb');
  }
}
     'debian': {
  file { '/etc/chrony/chrony.conf':
     owner  => root,
     group  => root,
     mode   => '0644',
     ensure => present,
     content => template('server_lite/chrony/debian_chrony.conf.erb');
   }
  }
}

case $::osfamily {
    'redhat': {
  service {
    'chronyd':
      require     => Package['chrony'],
      ensure      => running,
      enable      => true,
      hasstatus   => true,
      hasrestart  => true;
    }
  }
    'debian': {
  service {
    'chrony':
      require     => Package['chrony'],
      ensure      => running,
      enable      => true,
      hasstatus   => true,
      hasrestart  => true;
      }
    }
  }
}
