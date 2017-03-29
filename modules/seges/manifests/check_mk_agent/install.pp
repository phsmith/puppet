class seges::check_mk_agent::install (
  $version = $seges::params::check_mk_agent_version
) inherits seges::params { 

  case $::osfamily {
    'RedHat': {
      $source   = "http://nagios/nagios/check_mk/agents/check-mk-agent-${version}.noarch.rpm"
      $provider = 'rpm'
    }
    'Debian': {
      $source   = "http://nagios/nagios/check_mk/agents/check-mk-agent_${version}_all.deb"
      $provider = 'dpkg'
    }
    default: { fail 'Operating system not supported' } 
  }  

  package { 'xinetd':
    ensure => installed,    
  }

  package { 'check-mk-agent':
    ensure          => installed,
    provider        => $provider,
    source          => $source,
    install_options => '-Uvh',
    require         => Package['xinetd'],
  }

  service { 'xinetd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['xinetd'],
  }

}
