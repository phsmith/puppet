# Instalação de pacotes para e dependências do Fusion Inventory
class fusioninventory_agent::packages {
  case $::operatingsystem {
    'Ubuntu': {
    $dependencies = 'dmidecode'
      if $::operatingsystemmajrelease in ['8.04', '10.04', '11', '12', '13', '14.04'] {
        file { '/etc/apt/sources.list.d/fusioninventory.list':
          ensure  => present,
          content => template("${module_name}/fusioninventory.list.erb"),
          notify  => Package['fusioninventory-agent'],
        }
        exec { 'wget -O - http://debian.fusioninventory.org/debian/archive.key | sudo -E apt-key add -':
          path   => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
          onlyif => [ 'test -z "$(apt-key list | grep 4765572E)"' ]
        }
      }
    }
    'CentOS': {
      $dependencies = [ 'dmidecode', 'perl-Proc-Daemon', ]
    }
    default: { fail 'Operating system not supported.' }
  }

  package { $dependencies:
    ensure  => installed,
  }

  package { 'fusioninventory-agent':
    ensure => latest,
    name   => 'fusioninventory-agent*',
  }
}
