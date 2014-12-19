class grafanadash::dev() {
   include grafanadash::params
   package { 'selinux-utils':
       ensure => present,
       name   => $grafanadash::params::selinux_pkg,
   } ->
   package { 'iptables':
       ensure => present,
   } ->
   # hack; there is probably a module for this
   exec { '/usr/sbin/setenforce 0':
       unless  => '/usr/sbin/getenforce',
       require => Package['selinux-utils'],
   }

   # this is stupid, for anything other than dev
   case $::osfamily {
       'RedHat': {
           service { 'iptables':
              ensure => 'stopped',
           }
       }
       default: {
           exec { 'iptables -F':
               path => '/sbin:/usr/sbin',
           }
       }
   }

   $es_config_hash = {}

   package { 'cronie':
      ensure => present,
      name   => $grafanadash::params::cron_pkg,
   } ->
   class { 'epel':
   } ->
   class { 'graphite':
      gr_web_cors_allow_from_all => true,
      gr_timezone                => $::timezone,
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
   exec { '/bin/sleep 10':
   } ~>
   service { $grafanadash::params::apache_srv:
       ensure => running,
       enable => true,
   }

}
