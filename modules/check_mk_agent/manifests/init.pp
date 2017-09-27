# Class: check_mk_agent
# ===========================
#
# This module manages the installation of Check_MK Agent and Plugins
#
# Parameters
# ----------
#
# * `version`
# Check_MK agent version to be installed.
# Defaults to version 1.2.6p12.
#
# * `plugins`
# A list of Check_MK agent plugins to be installed
#
# * `agent_source`
# Source url for downloading Check_MK agent
#
# * `plugins_source`
# Source url for downloading Check_MK agent plugins
#
# Examples
# --------
#
# @example
#    class { 'check_mk_agent':
#      version    => '1.2.6-p12'
#      repository => 'http://check_mk_agent/plugins/repo',
#    }
#
# Authors
# -------
#
# Phillipe Smith <phillipelnx@gmail.com>
#
# Copyright
# ---------
#
# Copyright 2017 Phillipe Smith.
#
class check_mk_agent (
  String $version         = '1.2.6p12',
  Array[String] $plugins  = [],
  String $agent_source    = 'http://monitoramento.camara.leg.br/nagios/check_mk/agents',
  String $plugins_source  = 'http://10.1.3.113/repositorio/nagios/check_mk/plugins/linux',
  Boolean $noproxy        = false,
  Variant[String, Array[String]] $install_options = $::osfamily ? {
    'RedHat' =>  '-U',
    default  => '',
  }
) {
  # Workaround to ignore proxy environment settings
  if $noproxy {
    exec { '/bin/bash -c "export no_proxy=monitoramento.camara.leg.br"':
      onlyif => '/usr/bin/test ! -e /usr/bin/check_mk_agent',
      before => Package['check-mk-agent'],
    }
  }

  class { 'check_mk_agent::install':
    version => $version,
    source  => $agent_source,
    options => $install_options,
  }

  if $plugins and $::osfamily != 'Windows' {
    class { 'check_mk_agent::plugins':
      plugins => $plugins,
      source  => $plugins_source,
    }
  }
}
