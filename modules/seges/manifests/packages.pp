class seges::packages (
  $packages_list   = $seges::params::packages_list,
  $install_options = $seges::params::packages_install_options,  
) inherits seges::params {

  seges::epelrepo { 'epel-release':
    enable          => true,
    install_options => $packages_install_options,
  } ->

  seges::rpmforgerepo { 'rpmforge-release':
    enable          => false,
    install_options => $packages_install_options,
  } ->

  package { $packages_list:
    ensure  => installed,
  }

}
