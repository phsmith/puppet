define seges::check_mk_agent::plugins ($plugins) {

  if $plugins {
    $plugins.each | $plugin | {
      $plugin_path = "/usr/lib/check_mk_agent/plugins/${plugin}"

      exec { "cmk-plugin-${plugin}":
        path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
        command => "curl -o $plugin_path  http://10.1.3.113/repositorio/nagios/check_mk/plugins/linux/${plugin}",
        unless  => "test -f $plugin_path",
      }

      file { $plugin_path: 
        ensure  => file,
        mode    => 'a+x',
        require => Exec["cmk-plugin-${plugin}"]
      }
    }
  }
  else {
    fail('Error: no plugins have been especified.')
  }

}
