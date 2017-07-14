# Class: check_mk_agent::install
# ===========================
#
# Manages Check_MK agent installation
#
class check_mk_agent::install ($version, $source, $options='') {
  case $::osfamily {
    'RedHat': {
      $source_file = "${source}/check-mk-agent-${version}.noarch.rpm"
      $ensure      = $version
      $provider    = rpm
    }
    'Debian': {
      $source_file = "/tmp/check-mk-agent_${version}_all.deb"
      $ensure      = installed
      $provider    = dpkg

      exec { 'check-mk-agent-download':
        command => "/usr/bin/curl -s ${source}/check-mk-agent_${version}_all.deb -o ${source_file}",
        unless  => '/usr/bin/dpkg -l check-mk-agent',
        before  => Package['check-mk-agent'],
      }
    }
    default: { fail 'Operating system not supported' }
  }

  package { 'xinetd':
    ensure => installed,
  }

  package { 'check-mk-agent':
    ensure          => $ensure,
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
