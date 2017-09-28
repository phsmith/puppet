# Class: seges::users
# ===========================
#
# Class to manage system users
#
class seges::users (
    $login,
    $ensure,
    $managehome,
    $groups,
) {

  group { 'gestic':
    ensure => present,
    gid    => '1995400513',
  }

  file { '/etc/sudoers.d/seges':
    ensure  => present,
    content => '%seges ALL = (ALL) NOPASSWD: ALL',
  }

  #if $login {
  #  $login.each | $user | {
  #    exec { "userdel $user":
  #      command => "/usr/sbin/userdel ${user}",
  #      onlyif  => [ "/bin/grep ${user} /etc/passwd" ]
  #    }

  #    file { "/home/${user}":
  #      ensure  => directory,
  #      owner   => $user,
  #      group   => $groups,
  #      recurse => true,
  #      require => Package['sssd'],
  #    }
  #  }
  #}

  #exec { "/usr/sbin/groupdel seges":
  #  onlyif  => [ '/bin/grep seges /etc/group' ]
  #}

  #augeas { 'sudoseges':
  #  context => '/files/etc/sudoers',
  #  changes => [
  #    'set spec[user = "%seges"]/user %seges',
  #    'set spec[user = "%seges"]/host_group/host ALL',
  #    'set spec[user = "%seges"]/host_group/command ALL',
  #    'set spec[user = "%seges"]/host_group/command/runas_user ALL',
  #    'set spec[user = "%seges"]/host_group/command/tag NOPASSWD',
  #  ],
  #}
}
