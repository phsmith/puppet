# Serviço do fusion inventory
class fusioninventory_agent::services {
  service { 'fusioninventory-agent':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
