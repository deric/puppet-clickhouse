# @summary
#   Installs and configures Clickhouse client.
#
# @example Install Clickhouse client
#   class { 'clickhouse::client':
#     package_name   => 'clickhouse-client',
#     package_ensure => 'present',
#   }
#
# @param package_name
#   Name of Clickhouse client package to install. Defaults to 'clickhouse-client'.
# @param package_ensure
#   Whether the Clickhouse client package should be present, absent or specific version.
#   Valid values are 'present', 'absent' or 'x.y.z'. Defaults to 'present'.
# @param manage_package
#   Whether to manage Clickhouse client package. Defaults to 'true'.
# @param package_install_options
#   Array of install options for managed package resources. Appropriate options are passed to package manager.
#
class clickhouse::client (
  String $package_name,
  String $package_ensure,
  Boolean $manage_package,
  Array[String] $package_install_options,
) inherits clickhouse {
  if $clickhouse::client::manage_package {
    if ! defined(Package['clickhouse-common-static']) {
      package { 'clickhouse-common-static':
        ensure          => $clickhouse::client::package_ensure,
        install_options => $clickhouse::client::package_install_options,
      }
    }

    package { $clickhouse::client::package_name:
      ensure          => $clickhouse::client::package_ensure,
      install_options => $clickhouse::client::package_install_options,
      require         => Package['clickhouse-common-static'],
    }
  }
}
