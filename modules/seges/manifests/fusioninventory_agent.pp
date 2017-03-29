class seges::fusioninventory_agent ( 
  $server = $seges::params::fusioninventory_server 
) inherits seges::params {

  case $::operatingsystem {
    'Ubuntu': {
      $repopath     = '/etc/sources.list.d/fusioninventory.list'
      $command      = "curl -o $repopath http://10.1.3.113/repositorio/ubuntu/${::operatingsystemrelease}/fusioninventory.list"
      $dependencies = 'dmidecode'
    }
    'CentOS': {
      $repopath        = '/etc/yum.repos.d/fusioninventory.repo'
      $command         = "curl -o $repopath http://10.1.3.113/repositorio/centos/${::operatingsystemmajrelease}/fusioninventory.repo"
      $dependencies    = [ 'dmidecode', 'perl-Proc-Daemon' ]
      $install_options = $::operatingsystemmajrelease ? {
        '5'     => '--enablerepo=remi',
        '6'     => '--enablerepo=rpmforge',
        '7'     => '--disablerepo=fusioninventory',
        default => {}
      }
    }
    default: { fail 'Operating system not supported.' }
  }

  exec { 'fusioninventory-repo':
    path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    command => $command,
    unless  => "test -f $repopath",
  }

  # declarando que o agente do fusioninventory tem que estar sempre em sua ultima versao
  package { 'fusioninventory-agent*':
    ensure          => latest,
    require         => [Exec['fusioninventory-repo'], Package['rpmforge-release']],
    install_options => $install_options,
  }
    
  # declarando que os seguintes pacotes devem estar presentes
  package { $dependencies:
    ensure  => installed, 
  }

  # criando o arquivo de configuração do fusioninventory-agent
  file { '/etc/fusioninventory/agent.cfg':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '644',
    content => template("$module_name/fusioninventory-agent.cfg.erb"), 
    require => Package['fusioninventory-agent*'],
    notify  => Service['fusioninventory-agent'],
  }

  # verificação do serviço fusioninventory-agent	
  service { 'fusioninventory-agent':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

}
