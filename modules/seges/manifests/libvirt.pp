class seges::libvirt {

  package { 'libvirt':
    ensure => installed,
  }


  if $::operatingsystemmajrelease == '7' {
    exec { ['yum -y groupinstall "Virtualization host"']:
      path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
      unless  => 'yum grouplist "Virtualization host" | grep "^Installed"',
      timeout => 600 ,
    }
  }
  else {
    exec { ['yum -y groupinstall Virtualization']:
      path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
      unless  => 'yum grouplist "Virtualization" | grep "^Installed"',
      timeout => 600 ,
    }
  }
  
  exec { 'echo ""; echo "seges" | saslpasswd2 -a libvirt seges':
    path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    unless  => ['test -f /etc/libvirt/passwd.db', 'sasldblistusers2 -f /etc/libvirt/passwd.db | grep seges 2> /dev/null'],
    require => Package['libvirt'],
  }

  exec { 'sed -r -i "s/^#(listen_(tls|tcp))/\1/g" /etc/libvirt/libvirtd.conf':
    path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    onlyif  => ['grep -E "^#listen_(tls|tcp)" /etc/libvirt/libvirtd.conf'],
  }

  augeas { 'sysconfig-libvirtd':
    context => '/files/etc/sysconfig/libvirtd',
    changes => 'set LIBVIRTD_ARGS "--listen"',
    notify  => Service['libvirtd'],
  }

  augeas { 'libvirtd-conf':
    context => '/files/etc/libvirt/libvirtd.conf',
    changes => [
      'set listen_tls 0',
      'set listen_tcp 1',
    ],
    notify  => Service['libvirtd'],
  } 

  service { 'libvirtd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['libvirt'],
  }

}
