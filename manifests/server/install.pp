# @summary Private class for managing Clickhouse server package.
#
# @api private
#
class clickhouse::server::install {
  if $clickhouse::server::manage_package {
    if $clickhouse::server::apt_pin {
      case $facts['os']['family'] {
        'Debian': {
          if $clickhouse::server::apt_pin {
            apt::pin { 'clickhouse-server':
              packages => ['clickhouse-common-static', $clickhouse::server::package_name],
              priority => $clickhouse::server::pin_priority,
              version  => $clickhouse::server::apt_pin,
            }
          }
        }
        default: {}
      }
    }

    package { 'clickhouse-common-static':
      ensure          => $clickhouse::server::package_ensure,
      install_options => $clickhouse::server::package_install_options,
    }

    package { $clickhouse::server::package_name:
      ensure          => $clickhouse::server::package_ensure,
      install_options => $clickhouse::server::package_install_options,
      require         => Package['clickhouse-common-static'],
    }

    if $clickhouse::server::manage_service {
      Package<| title == $clickhouse::server::package_name |> {
        notify => Service[$clickhouse::server::service_name],
      }
    }
  }
}
