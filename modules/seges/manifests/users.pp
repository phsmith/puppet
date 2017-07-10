# Seges users puppet class
class seges::users (
    $users      = $seges::params::users,
    $ensure     = $seges::params::users_ensure,
    $managehome = $seges::params::users_managehome,
    $groups     = $seges::params::users_groups,
) inherits seges::params {

  group { 'seges':
    ensure => present,
  }

  if $users {
    user { $users:
      ensure     => $ensure,
      groups     => $groups,
      managehome => $managehome,
      require    => Group['seges'],
    }
  }

  augeas { 'sudoseges':
    context => '/files/etc/sudoers',
    changes => [
      'set spec[user = "%seges"]/user %seges',
      'set spec[user = "%seges"]/host_group/host ALL',
      'set spec[user = "%seges"]/host_group/command ALL',
      'set spec[user = "%seges"]/host_group/command/runas_user ALL',
      'set spec[user = "%seges"]/host_group/command/tag NOPASSWD',
    ],
  }

}
