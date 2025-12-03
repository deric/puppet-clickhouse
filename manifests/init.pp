# @summary
#   Installs and configures Clickhouse
#
# @param manage_repo
#   Whether to install Clickhouse repository.
# @param apt_pin which version to pin to
# @param pin_priority Debian list priority
# @param pin_packages which packages should pin apply to
class clickhouse (
  Boolean $manage_repo,
  Optional[String] $apt_pin = undef,
  Integer $pin_priority = 1001,
  Array[String] $pin_packages = ['clickhouse-common-static']
) {
  if $manage_repo {
    include clickhouse::repo

    if $apt_pin {
      case $facts['os']['family'] {
        'Debian': {
          apt::pin { 'clickhouse':
            packages => $pin_packages,
            priority => $pin_priority,
            version  => $apt_pin,
          }
        }
        default: {}
      }
    }
  }
}
