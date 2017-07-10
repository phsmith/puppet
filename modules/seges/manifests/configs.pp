# Seges configs puppet class
class seges::configs {

  if $::operatingsystem == 'CentOS' and $::operatingsystemmajrelease == '7' {
    file { '/etc/nslcd.conf':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0600',
      source => "puppet:///modules/${module_name}/nslcd.conf",
      notify => Service['nslcd'],
    }

    file { '/etc/ntp.conf':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => "puppet:///modules/${module_name}/chrony.ntp.conf",
    }
  }
  else {
    file { '/etc/pam_ldap.conf':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => "puppet:///modules/${module_name}/pam_ldap.conf",
    }

    file { '/etc/ntp.conf':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => "puppet:///modules/${module_name}/ntp.conf",
    }
  }

  file { '/etc/profile.d/path.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "pathmunge /usr/local/bin\nunset -f pathmunge",
  }

  file { '/etc/yum.repos.d/fusioninventory.repo':
    ensure => absent
  }

  augeas { 'selinux_disable':
    context => '/files/etc/selinux/config/',
    changes => [ 'set SELINUX disabled' ],
    onlyif  => 'match SELINUX != [ "disabled" ]',
  }

  exec { 'setenforce 0':
    path   => '/bin:/sbin:/usr/bin:/usr/sbin',
    onlyif => 'test ! `getenforce` = "Disabled"',
  }

  augeas { 'sshd_config':
    context => '/files/etc/ssh/sshd_config',
    changes => [ 'set GSSAPIAuthentication no' ],
    onlyif  => 'match GSSAPIAuthentication != [ "no" ]',
  }

}
