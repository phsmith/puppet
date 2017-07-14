# Class: check_mk_agent::plugins
# ===========================
#
# Manages Check_MK Agent plugins
#
class check_mk_agent::plugins ($plugins, $source) {
  if $plugins {
    $plugins.each | $plugin | {
      $plugin_path = "/usr/lib/check_mk_agent/plugins/${plugin}"

      exec { "cmk-plugin-${plugin}":
        path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
        command => "curl -o ${plugin_path}  ${source}/${plugin}",
        unless  => "/bin/bash -c 'diff <(cat ${plugin_path}) <(curl -s ${source}/${plugin})'",
      }

      file { $plugin_path:
        ensure  => present,
        mode    => 'a+x',
        require => Exec["cmk-plugin-${plugin}"]
      }
    }
  }
  else {
    fail('Error: no plugins have been especified.')
  }
}
