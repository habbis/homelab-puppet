# setup postfix  amil relay
class roles::postfix_mta (
# @param smtp_server
# @param email_user
# @param email_password
  String  $smtp_relay_server,
  Integer $smtp_relay_port,
  String  $email_relay_user,
  String  $email_relay_password,) {

if $facts['os']['family'] =='Debian' {
  package {
    'postfix':    ensure => installed;
    'mailutils':  ensure => installed;
    'libsasl2-2': ensure => installed;
    'pdns-tools': ensure => installed;
  }

  file { '/etc/postfix/main.cf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => epp('roles/postfix_mta/debian_main.cf.epp');
  }

  file { '/etc/postfix/sasl_passwd':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0600',
    content => epp('roles/postfix_mta/debian_sasl_passwd.epp');
  }
    service {
      'postfix':
        ensure     => running,
        require    => Package['postfix'],
        enable     => true,
        hasstatus  => true,
        hasrestart => true;
    }
  exec {
    'postfix_main_systemd_restart':
      command     => 'systemctl restart postfix.service',
      path        => ['/bin','/usr/bin', '/usr/sbin'],
      subscribe   => File['/etc/postfix/main.cf'],
      refreshonly => true
    }
  exec {
    'postfix_sasl_systemd_restart':
      command     => 'systemctl restart postfix.service',
      path        => ['/bin','/usr/bin', '/usr/sbin'],
      subscribe   => File['/etc/postfix/sasl_passwd'],
      refreshonly => true
    }
  }
}
