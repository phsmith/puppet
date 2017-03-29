define seges::epelrepo (
  $ensure = 'installed',
  $enable = false,
  $install_options = '',
  $source = $::operatingsystemmajrelease ? {
    '5'     => 'http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm',
    '6'     => 'http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm',
    '7'     => 'http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm',
    default => {}
  },
) {
  package { "$name":
    ensure          => $ensure,
    provider        => rpm,
    source          => $source,
    install_options => $install_options,
  }
  
}
