class grafanadash::params {
    case $::osfamily {
        'Debian': {
            $cron_pkg = 'cron'
            $apache_srv = 'apache2'
            $selinux_pkg = 'selinux-utils'
        }
        'RedHat': {
            $cron_pkg = 'cronie'
            $apache_srv = 'httpd'
            $selinux_pkg = 'libselinux-utils'
        }
        default: {
            fail ("Your OS (${::osfamily}) is not supported by ${module_name}")
        }
    }
}
