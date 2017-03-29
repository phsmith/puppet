class seges::configs {

  if $::operatingsystem == 'CentOS' and $::operatingsystemmajrelease == '7' {
    file { '/etc/nslcd.conf':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '600',
      source  => "puppet:///modules/$module_name/nslcd.conf",
    }
    
    file { '/etc/ntp.conf':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '644',
      source  => "puppet:///modules/$module_name/chrony.ntp.conf",
    }
  }
  else {
    file { '/etc/pam_ldap.conf':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '644',
      source  => "puppet:///modules/$module_name/pam_ldap.conf",
    }
  
    file { '/etc/ntp.conf':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '644',
      source  => "puppet:///modules/$module_name/ntp.conf",
    }
  }

  file { '/etc/profile.d/path.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '644',
    content => "pathmunge /usr/local/bin\nunset -f pathmunge",
  }

  augeas { 'selinux_disable':
    context => '/files/etc/selinux/config/',
    changes => [ 'set SELINUX disabled' ],
    onlyif  => 'match SELINUX != [ "disabled" ]',
  }

  augeas { 'sshd_config': 
    context => '/files/etc/ssh/sshd_config',
    changes => [ 'set GSSAPIAuthentication no' ],
    onlyif  => 'match GSSAPIAuthentication != [ "no" ]',
  }

}
