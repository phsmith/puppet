# Class: seges::dellopenmanager
# ===========================
#
# Class to manage Dell Openmanager installation and configuration
#
class seges::dellopenmanager {

  file { '/etc/yum.repos.d/dell-omsa-repository.repo':
    ensure => 'absent',
  }

  exec { 'dellopenmanager-repo':
    path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    environment => ['http_proxy=http://10.1.0.99:5865'],
    command     => 'wget -c -q -O - http://linux.dell.com/repo/hardware/latest/bootstrap.cgi | bash',
    unless      => 'test -f /etc/yum.repos.d/dell-system-update.repo 2> /dev/null',
  }

  package { ['net-snmp', 'OpenIPMI', 'srvadmin-all', 'dell-system-update']:
    ensure => 'installed',
  }

  exec { 'dsu -n &> /var/log/dell/dell-system-update.log':
    path   => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    unless => 'test ! -f /var/log/dell/dell-system-update.log',
  }

  file { '/etc/snmp/snmpd.conf':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => "puppet:///modules/${module_name}/snmpd.conf",
  }

  service { ['snmpd', 'ipmi', 'dataeng']:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['net-snmp', 'OpenIPMI', 'srvadmin-all'],
  }

}
