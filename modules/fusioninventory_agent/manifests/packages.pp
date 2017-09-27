# Class: fusioninventory_agent::packages
# =======================================
#
# Class to manage fusioninventory-agent packages
# to be installed.
#
class fusioninventory_agent::packages {

  $packages = [
    'fusioninventory-agent',
    'fusioninventory-agent-task-deploy',
    'fusioninventory-agent-task-esx',
    'fusioninventory-agent-task-network',
  ]

  case $::operatingsystem {
    'Ubuntu': {
      $dependencies = 'dmidecode'

      if $::operatingsystemmajrelease in ['8.04', '10.04', '11', '12', '13', '14.04'] {
        file { '/etc/apt/sources.list.d/fusioninventory.list':
          ensure  => present,
          content => template("${module_name}/fusioninventory.list.erb"),
        }
        exec { 'wget -O - http://debian.fusioninventory.org/debian/archive.key | sudo -E apt-key add -':
          path   => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
          onlyif => [ 'test -z "$(apt-key list | grep 4765572E)"' ]
        }
      }
    }
    'CentOS': {
      $dependencies = [ 'dmidecode', 'perl-Proc-Daemon', ]

      file { '/etc/yum.repos.d/fusioninventory.repo':
        ensure => absent,
      }

    }
    default: { fail 'Operating system not supported.' }
  }

  package { $dependencies:
    ensure  => installed,
  }

  package { $packages:
    ensure => installed,
  }
}
