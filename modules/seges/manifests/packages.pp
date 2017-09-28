# Class: seges::packages
# ===========================
#
# Class to manage packages installation
#
class seges::packages (
  $packages_list,
  $install_options,
) {
  if $::operatingsystem == 'CentOS' {
    class { 'epel':
      epel_mirrorlist => "https://mirrors.fedoraproject.org/mirrorlist?repo=epel-${::operatingsystemmajrelease}&arch=\$basearch&country=US",
    }

    exec { 'remove-old-fusioninventory':
      path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
      command => 'yum -y remove fusioninventory-agent*',
      onlyif  => [ 'test "`rpm -qa | grep fusioninventory-agent`"', 'test "`rpm -qi fusioninventory-agent | grep -o Vendor.*guillomovitch`"' ],
    }
    
    package { ['nss-pam-ldapd', 'pam_ldap']: 
      ensure => absent,
    }

  }

  package { $packages_list:
    ensure          => installed,
    install_options => $install_options,
  }
}
