# Configurações do agente do Fusion Inventory
class fusioninventory_agent::config {
  file { '/etc/fusioninventory/agent.cfg':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/fusioninventory-agent.cfg.erb"),
    require => Package['fusioninventory-agent'],
    notify  => Service['fusioninventory-agent'],
  }
}
