# Classe responsável por instalar o agente do Check_MK
class check_mk_agent::install ($version, $source, $options='') {

  case $::osfamily {
    'RedHat': {
      $source_file = "${source}/check-mk-agent-${version}.noarch.rpm"
      $provider    = 'rpm'
    }
    'Debian': {
      $source_file = "${source}/check-mk-agent_${version}_all.deb"
      $provider    = 'dpkg'
    }
    default: { fail 'Operating system not supported' }
  }

  package { 'xinetd':
    ensure => installed,
  }

  package { 'check-mk-agent':
    ensure          => $version,
    provider        => $provider,
    source          => $source_file,
    install_options => $options,
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
