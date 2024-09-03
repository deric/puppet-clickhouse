# @summary Private class for managing Clickhouse client package.
#
# @api private
#
class clickhouse::client::install {
  if $clickhouse::client::manage_package {
    package { 'clickhouse-common-static':
      ensure          => $clickhouse::client::package_ensure,
      install_options => $clickhouse::client::package_install_options,
    }

    package { $clickhouse::client::package_name:
      ensure          => $clickhouse::client::package_ensure,
      install_options => $clickhouse::client::package_install_options,
      require         => Package['clickhouse-common-static'],
    }
  }
}
