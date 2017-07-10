# Class: fusioninventory_agent
# ===========================
#
# Class to manage Fusioninventory_agent Agent installation
#
# Parameters
# ----------
#
# * `server`
# Specify the fusioninventory_agent server 
#
# Examples
# --------
#
# @example
#    class { 'fusioninventory_agent':
#      server => 'http://server/glpi/plugins/fusioninventory_agent',
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
class fusioninventory_agent ( $server = 'http://localhost/glpi/plugins/fusioninventory_agent/' ) {
  include fusioninventory_agent::packages
  include fusioninventory_agent::config
  include fusioninventory_agent::services
}
