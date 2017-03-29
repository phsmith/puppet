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
# [*fusioninventory_server*]
# Url for GLPI/Fusioninventory server
#
# [*check_mk_agent_version*]
# The check_mk_agent version to be installed
#
# [*check_mk_agent_plugins*]
# Aditional check_mk_agent plugins
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
  Boolean $basic_install                        = $seges::params::basic_install,
  Array[String] $packages_install_options       = $seges::params::packages_install_options,
  Variant[Undef, Array[String]] $packages_list  = $seges::params::packages_list,
  Variant[Undef, String, Array[String]] $users  = $seges::params::users,
  String $fusioninventory_server                = $seges::params::fusioninventory_server,
  String $check_mk_agent_version                = $seges::params::check_mk_agent_version,
  Array[String] $check_mk_agent_plugins         = $seges::params::check_mk_agent_plugins,
) inherits seges::params {

  if $basic_install {
    include seges::configs
    include seges::services
    include seges::check_mk_agent::install

    if $users != $seges::params::users {
      class { 'seges::users':
        users => $users << $seges::params::users
      }
    } 
    else {
      class { 'seges::users':
        users => $users
      }
    }

    if $packages_list != $seges::params::packages_list {
      $_packages_list = $seges::params::packages_list << $packages_list
    }
    else {
      $_packages_list = $seges::params::packages_list
    }
    
    class { 'seges::packages': 
      packages_list   => $_packages_list,
      install_options => $packages_install_options,
    }
    
    class { 'seges::fusioninventory_agent':
      server => $fusioninventory_server,
    }
    
    if $check_mk_agent_plugins != $seges::params::check_mk_agent_plugins {
      $_check_mk_agent_plugins = $seges::params::check_mk_agent_plugins << $check_mk_agent_plugins
    }
    else {
      $_check_mk_agent_plugins = $check_mk_agent_plugins
    }

    seges::check_mk_agent::plugins { 'check_mk_plugins':
      plugins => $check_mk_agent_plugins
    }
  }

  if $::virtual == 'physical' {
    include seges::dellopenmanager
    include seges::libvirt
    Class[::seges] -> Class[::seges::dellopenmanager]
  }

  Class[::seges::packages] -> 
  Class[::seges::configs] -> 
  Class[::seges::users] -> 
  Class[::seges::services] ->
  Class[::seges]
}
