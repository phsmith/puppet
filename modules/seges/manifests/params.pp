class seges::params {

  $basic_install = false
 
  ### Users vars ###
  $users_ensure       = present
  $users_managehome   = true
  $users_groups       = [ 'seges' ]
  $default_users = [ 
    'p_6678', 
    'p_7007', 
    'p_7029', 
    'p_991118', 
    'p_991150', 
    'p_991266', 
    'p_999138', 
  ]
 
  if $::operatingsystem == 'CentOS' and $::operatingsystemmajrelease == '7' {
    $users = $default_users.map | $user | { upcase($user) } + $default_users
  } 
  else {
    $users = $default_users
  }
  
  ### Packages vars ###
  $default_packages_list = [
    'at',
    'bash-completion',
    'git',
    'htop',
    'iotop',
    'lftp',
    'links',
    'man',
    'mlocate',
    'openssh-clients',
    'vim',
    'wget',
    'zip',
    'unzip',
  ]
  
  case $::operatingsystem {
    'CentOS': {
      $ntp = $::operatingsystemmajrelease ? {
        '7'     => 'chrony',
        default => 'ntp',
      }

      $packages_list = $default_packages_list + [ 
        'bind-utils', 
        'nfs-utils', 
        'nss-pam-ldapd', 
        'openssh-ldap', 
        'pam_ldap', 
        'pam_ssh',
        $ntp,
      ]

      $packages_install_options = [
        '--httpproxy', '10.1.0.99', 
        '--httpport' , '5865',
      ]
    }
    'Ubuntu': {
      $packages_list = $default_packages_list + [
        'ldap-auth-client',
        'ldap-auth-config',
        'libnss-ldap',
        'libpam-ldap',
        'nfs-common',
        'ntp',
      ]
    }
    default: {
      $packages_list = $default_packages_list
      $packages_install_options = undef
    }
  }

  ### Fusioninventory vars ###
  $fusioninventory_server = 'http://corsa.redecamara.camara.gov.br/glpi/plugins/fusioninventory/'
 
  ### Check_mk vars ###
  $check_mk_agent_version = '1.2.6p12-1'
  $check_mk_agent_plugins = ['lvm', 'mk_logins']
}
