class seges::omd inherits seges::params {
  
  case $::operatingsystem {
    'CentOS': {
      $os_version = $::operatingsystemmajrelease
      $omdrepo    = "https://labs.consol.de/repo/stable/rhel${os_version}/x86_64/labs-consol-stable.rhel${os_version}.noarch.rpm"
      $provider   = 'rpm' 
    }
    default: {}
  }

  package { 'omdrepo':
    name            => 'omd',
    ensure          => installed,
    provider        => $provider,
    source          => $omdrepo,
    install_options => [ '-Uvh' ] + $packages_install_options,
  }

  package { 'omd':
    ensure          => installed,
    require         => Package['omdrepo'],
    install_options => '--setopt=timeout=600',
  }
}
