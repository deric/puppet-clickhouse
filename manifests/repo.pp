# @summary
#   Installs repository for Clickhouse.
#
# @example
#   include clickhouse::repo
class clickhouse::repo {
  case $facts['os']['family'] {
    default: {
      fail("${facts['os']['family']} is not supported (yet).")
    }

    'Debian': {
      apt::source { 'clickhouse':
        location => 'https://packages.clickhouse.com/deb',
        release  => 'stable main',
        repos    => '',
        key      => {
          id     => '3A9EA1193A97B548BE1457D48919F6BD2B48D754',
          server => 'hkp://keyserver.ubuntu.com:80',
        },
      }
    }
    'RedHat': {
      yumrepo { 'clickhouse-altinity':
        name     => 'clickhouse-altinity',
        descr    => 'Altinity clickhouse repository',
        baseurl  => "https://packagecloud.io/altinity/clickhouse/el/\$releasever/\$basearch",
        enabled  => 1,
        gpgcheck => 0,
        gpgkey   => 'https://packagecloud.io/altinity/clickhouse/gpgkey',
      }
    }
  }
}
