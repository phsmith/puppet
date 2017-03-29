define seges::rpmforgerepo (
  $ensure = 'installed',
  $enable = false,
  $source = "http://repoforge.xpg.com.br/redhat/el${::operatingsystemmajrelease}/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.3-1.el${::operatingsystemmajrelease}.rf.x86_64.rpm",
  $install_options = '',
) {
  package { $name:
    ensure          => $ensure,
    provider        => rpm,
    source          => $source,
    install_options => $install_options,
  }

  yumrepo { 'rpmforge':
    enabled => 0,
    require => Package[$name],
  }
  
}
