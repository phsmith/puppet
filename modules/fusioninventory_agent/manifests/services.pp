# Class: fusioninventory_agent::services
# =======================================
#
# Class to manage fusioninventory-agent service
#
class fusioninventory_agent::services {
  service { 'fusioninventory-agent':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
