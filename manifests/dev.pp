class grafanadash::dev() {
   # hack; there is probably a module for this
   exec { '/usr/sbin/setenforce 0': }

   # this is stupid, for anything other than dev
   service { 'iptables':
      ensure => 'stopped',
   }

   $es_config_hash = {}

   package { 'cronie':
      ensure => present,
   } ->
   class { 'epel':
   } ->
   class { 'graphite':
      gr_web_cors_allow_from_all => true,
   } ->
   class { 'elasticsearch':
      java_install => true,
      manage_repo  => true,
      repo_version => '1.0',
      config => $es_config_hash,
   } ->
   class { 'grafanadash::grafana':
      graphite_host => $::graphite::gr_web_servername,
      graphite_port => $::graphite::gr_apache_port,
      elasticsearch_host => $::fqdn,
      grafana_host => $::fqdn,
   } ->
   # super hacky but for some reason the graphite database is coming up
   # as locked until we restart apache?
   exec { '/sbin/service httpd restart': }

}
