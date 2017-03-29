class seges::services {

  if $::operatingsystemmajrelease == '7' {
    $ensure_nslcd     = running
    $firewall_service = 'firewalld'
    $ntp_service      = 'chronyd'
    $ntp_package      = 'chrony'
  } 
  else {
    $ensure_nslcd     = stopped
    $firewall_service = 'iptables'
    $ntp_service      = 'ntpd'
    $ntp_package      = 'ntp'
  }

  service { $ntp_service:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package[$ntp_package],
  }

  service { $firewall_service: 
    ensure => stopped,
    enable => false,
    hasstatus  => true,
    hasrestart => true,
  }

  service { 'nslcd':
    ensure     => $ensure_nslcd,
    enable     => false,
    hasstatus  => true,
    hasrestart => true,
  }

  exec { 'authconfig-ldap':
    path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    command => '/usr/sbin/authconfig --update --enableldap --enableldapauth --enableforcelegacy \
      --ldapserver=dirsrvc.camara.gov.br --ldapbasedn=ou=usuarios,dc=redecamara,dc=camara,dc=gov,dc=br --updateall',
    unless  => ['grep "FORCELEGACY=yes" /etc/sysconfig/authconfig'],
  }

}
