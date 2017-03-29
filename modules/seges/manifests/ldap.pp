class seges::ldap {

  case $::operatingsystem {
    'CentOS': {
      $packages_list = [
        'nss-pam-ldapd',
        'openssh-ldap',
        'pam_ldap',
      ]
   
      if $::operatingsystemmajrelease == '7' {
        file { '/etc/nslcd.conf':
          ensure  => file,
          owner   => 'root',
          group   => 'root',
          mode    => '600',
          source  => "puppet:///modules/$module_name/nslcd.conf",
        }
        
      }
      else {
        file { '/etc/pam_ldap.conf':
          ensure  => file,
          owner   => 'root',
          group   => 'root',
          mode    => '644',
          source  => "puppet:///modules/$module_name/pam_ldap.conf",
        }
      }
  
      service { 'nslcd':
        ensure     => running,
        enable     => false,
        hasstatus  => true,
        hasrestart => true,
      }
    }
    'Ubuntu': {
      $packages_list = [
        'ldap-auth-client',
        'ldap-auth-config',
        'libnss-ldap',
        'libpam-ldap',
      ]
      
      file { '/etc/ldap.conf':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '644',
        content => "puppet:///modules/$module_name/pam_ldap.conf",
      }
    }
    default: {}
  }

  package { $packages_list:
    ensure => installed,
  }

  exec { 'authconfig-ldap':
    path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    command => 'authconfig --update --enableldap --enableldapauth --enableforcelegacy \
      --ldapserver=dirsrvc.camara.gov.br --ldapbasedn=ou=usuarios,dc=redecamara,dc=camara,dc=gov,dc=br --updateall',
    unless  => ['grep "FORCELEGACY=yes" /etc/sysconfig/authconfig'],
  }

}
