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
      apt::source { 'clickhouse-yandex':
        location => 'http://repo.yandex.ru/clickhouse/deb/stable/',
        release  => 'main/',
        repos    => '',
        key      => {
          id     => '9EBB357BC2B0876A774500C7C8F1E19FE0C56BD4',
          server => 'hkp://keyserver.ubuntu.com:80',
        },
      }
      Apt::Source['clickhouse-yandex'] -> Package <| |>
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
      Yumrepo['clickhouse-altinity'] -> Package <| |>
    }
  }

}
