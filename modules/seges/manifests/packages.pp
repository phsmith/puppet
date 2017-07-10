# Seges packages puppet class
class seges::packages (
  $packages_list   = $seges::params::packages_list,
  $install_options = $seges::params::packages_install_options,
) inherits seges::params {
  exec { 'remove-old-fusioninventory':
    path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
    command => 'yum -y remove fusioninventory-agent*',
    onlyif  => [ 'test "`rpm -qi fusioninventory-agent | grep -o Vendor.*guillomovitch`"' ],
  }

  if $::osfamily == 'RedHat' {
    class { 'seges_epel':
      install_options => $install_options,
    }
  }

  #seges::rpmforgerepo { 'rpmforge-release':
  #  enable          => false,
  #  install_options => $packages_install_options,
  #} ->

  package { $packages_list:
    ensure  => installed,
  }

}
