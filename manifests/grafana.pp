class grafanadash::grafana (
    $version            = $grafanadash::params::version,
    $download_url       = $grafanadash::params::download_url,
    $install_dir        = $grafanadash::params::install_dir,
    $symlink            = $grafanadash::params::symlink,
    $symlink_name       = $grafanadash::params::symlink_name,
    $user               = $grafanadash::params::user,
    $group              = $grafanadash::params::group,
    $graphite_host      = $grafanadash::params::graphite_host,
    $graphite_port      = $grafanadash::params::graphite_port,
    $elasticsearch_host = $grafanadash::params::elasticsearch_host,
    $elasticsearch_port = $grafanadash::params::elasticsearch_port,
    $grafana_host       = $grafanadash::params::grafana_host,
    $grafana_port       = $grafanadash::params::grafana_port,
) inherits grafanadash::grafana::params {
    archive { "grafana-${version}":
        ensure      => present,
        url         => $download_url,
        target      => $install_dir,
        checksum    => false,
    } ->

    file { "${install_dir}/grafana-${version}/config.js":
        ensure  => present,
        content => template('grafanadash/opt/grafana/config.js.erb'),
        owner   => $user,
        group   => $group,
        require => Archive["grafana-${version}"],
    } ->

    file { $symlink_name:
        ensure  => link,
        target  => "${install_dir}/grafana-${version}",
        require => Archive["grafana-${version}"],
    } ->

   file { "${::graphite::params::apacheconf_dir}/grafana.conf":
      ensure => file,
      owner => $::grafanadash::grafana::params::user,
      group => $::grafanadash::grafana::params::group,
      mode  => '0644',
      content => template('grafanadash/etc/apache2/sites-available/grafana.conf.erb'),
      notify => Service[$::graphite::params::apache_service_name],
   }

}
