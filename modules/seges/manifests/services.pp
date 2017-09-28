# Class: seges::services
# ===========================
#
# Class to manage seges modules services
#
class seges::services($args) {

  if $::osfamily == 'RedHat'{
    exec { 'authconfig-ldap':
      path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
      command => 'authconfig --enablemkhomedir --disableldap --disableldapauth --enablesssd \
        --enablesssdauth --disableforcelegacy --ldapserver=dirsrvc.camara.gov.br \
        --ldapbasedn=ou=usuarios,dc=redecamara,dc=camara,dc=gov,dc=br --updateall',
      onlyif  => ['grep -E "(USESSSDAUTH=no|FORCELEGACY=yes)" /etc/sysconfig/authconfig'],
    }
  }

  service { 'sssd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['sssd'],
  }

  service { $args['ntp_service']:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package[$args['ntp_package']],
  }

  service { $args['firewall_service']:
    ensure     => stopped,
    enable     => false,
    hasstatus  => true,
    hasrestart => true,
  }
}
