# Class: seges::configs
# ===========================
#
# Class to manage configuration files
#
class seges::configs ($args) {

  if $::operatingsystem == 'CentOS' {
    file { '/etc/profile.d/path.sh':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "pathmunge /usr/local/bin\nunset -f pathmunge",
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
  }

  file { $args['ldap_file']:
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => $args['ldap_file_mode'],
    source => $args['ldap_file_src'],
    notify => Service[$args['ldap_service']],
  }

  file { $args['ntp_file']:
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => $args['ntp_file_src'],
    notify => Service[$args['ntp_service']],
  }

  augeas { 'sshd_config':
    context => '/files/etc/ssh/sshd_config',
    changes => [ 'set GSSAPIAuthentication no' ],
    onlyif  => 'match GSSAPIAuthentication != [ "no" ]',
  }
}
