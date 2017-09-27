# Class: fusioninventory_agent
# =============================
#
# Class to manage Fusioninventory_agent Agent installation
#
# Parameters
# ----------
#
# * `server`
# Specify the fusioninventory_agent server 
#
# * `agent_tag`
# Specify a tag to the agent
#
# Examples
# --------
#
# @example
#    class { 'fusioninventory_agent':
#      agent_tag => 'SEGES',
#      server    => 'http://server/glpi/plugins/fusioninventory_agent',
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
class fusioninventory_agent ( 
  String $agent_tag,
  String $server = 'http://corsa.redecamara.camara.gov.br/glpi/plugins/fusioninventory/',
) {
  include fusioninventory_agent::packages
  include fusioninventory_agent::config
  include fusioninventory_agent::services
}
