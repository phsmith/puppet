# Class: check_mk_agent::install
# ===========================
#
# Manages Check_MK agent installation
#
class check_mk_agent::install ($version, $source, $options='') {
  case $::osfamily {
    'RedHat': {
      $source_file = "${source}/check-mk-agent-${version}-1.noarch.rpm"
      $ensure      = $version
      $provider    = rpm
    }
    'Debian': {
      $source_file = "/tmp/check-mk-agent_${version}_all.deb"
      $ensure      = held
      $provider    = dpkg

      exec { 'check-mk-agent-download':
        path    => [ '/bin:/sbin:/usr/bin:/usr/sbin' ],
        command => "curl -s ${source}/check-mk-agent_${version}-1_all.deb -o ${source_file}",
        onlyif  => [
          'test -z "$(dpkg -l check-mk-agent)"',
          "test ! $(dpkg-query -W -f '\${Version}' check-mk-agent) = ${version}",
          'test "$(dpkg-query -W -f "${Status}" check-mk-agent)" = "hold ok installed"'
        ],
        before  => Package['check-mk-agent'],
      }
    }
    'Windows': {
      $package_name = $::architecture ? {
        'x64'   => "install_agent-64-${version}.exe",
        default => "install_agent-${version}.exe",
      }

      file { "C:\\temp\\${package_name}":
        ensure             => file,
        mode               => '0755',
        source             => "puppet:///modules/${module_name}/${package_name}",
        source_permissions => ignore,
      }

      package { "Check_MK Agent ${version}":
        ensure          => installed,
        source          => "C:\\temp\\${package_name}",
        install_options => [ 'install', '/S' ],
        require         => File["C:\\temp\\${package_name}"],
      }
    }
    default: { fail 'Operating system not supported' }
  }

  if $::osfamily != 'Windows' {
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

    file { '/usr/lib/check_mk_agent/plugins':
      ensure => directory,
    }

    service { 'xinetd':
      ensure     => running,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
      require    => Package['xinetd'],
    }
  }
}
