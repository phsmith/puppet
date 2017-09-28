# Class: seges
# ===========================
#
# Class to manage SEGES infraestructure
#
# Parameters
# ----------
#
# [*basic_install*]
# Set it equal to true if you want to made the basic system installation and configuration.
# Install some useful packages to the system, epel repository on CentOS system,
# config ldap authentication, install check_mk and fusioninventory agents
#
# [*packages_list*]
# A list of packages to be installed on the system
#
# [*packages_install_options*]
# Custom options do parse to the package manager provider
#
# [*users*]
# A user, or list of users, to be created on the system
#
# [*fusioninventory_agent_server*]
# Url for GLPI/Fusioninventory server
#
# [*fusioninventory_agent_tag*]
# Custom tag for fusioninventory agent
#
# [*check_mk_agent_version*]
# The check_mk_agent version to be installed
#
# [*check_mk_agent_plugins*]
# Aditional check_mk_agent plugins
#
# [*check_mk_agent_plugins_source*]
# Source url to download check_mk_agent plugins
#
# Examples
# --------
#
# @example
#    class { 'seges':
#      basic_install => true,
#      users         => [ 'user1', 'user2', 'user3' ],
#    }
#
# Authors
# -------
#
# Phillipe Smith <phillipe.chaves@camara.leg.br>
#
# Copyright
# ---------
#
# Copyright 2016 Câmara dos Deputados - CAINF/SEGES.
#
class seges (
  Boolean $basic_install,
  String $fusioninventory_agent_server,
  String $fusioninventory_agent_tag,
  String $check_mk_agent_version,
  String $check_mk_agent_plugins_source,
  Array[String] $check_mk_agent_plugins,
  Array[String] $packages_install_options       = lookup('seges::packages::install_options'),
  Variant[Undef, Array[String]] $packages_list  = lookup('seges::packages::packages_list'),
  Variant[Undef, String, Array[String]] $users  = lookup('seges::users::login'),
) {

  if $basic_install {
    $default_packages_list          = lookup('seges::packages::packages_list')
    $default_check_mk_agent_plugins = lookup('seges::check_mk_agent_plugins')

    if $packages_list != $default_packages_list {
      $_packages_list = concat($default_packages_list, $packages_list)
    }
    else {
      $_packages_list = $packages_list
    }

    if $check_mk_agent_plugins != $default_check_mk_agent_plugins {
      $_check_mk_agent_plugins = concat($default_check_mk_agent_plugins, $check_mk_agent_plugins)
    }
    else {
      $_check_mk_agent_plugins = $check_mk_agent_plugins
    }

    include seges::configs
    include seges::services

    class {'seges::users':
      login => $users,
    }

    class { 'seges::packages':
      packages_list   => $_packages_list,
      install_options => $packages_install_options,
    }

    class { '::check_mk_agent':
      plugins => $_check_mk_agent_plugins,
    }

    class { '::fusioninventory_agent':
      agent_tag => $fusioninventory_agent_tag,
      server    => $fusioninventory_agent_server,
    }
  }

  if $::virtual == 'physical' {
    include seges::dellopenmanager
    include seges::libvirt
    Class[::seges] -> Class[::seges::dellopenmanager]
  }

  Class[::seges::packages]
  -> Class[::seges::configs]
  -> Class[::seges::services]
  -> Class[::seges::users]
}
