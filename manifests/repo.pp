# @summary
#   Installs repository for Clickhouse.
#
# @example
#   include clickhouse::repo
class clickhouse::repo {
  case $facts['os']['family'] {
    'Debian': {
      # `*.asc` for ASCII armored keys
      apt::keyring { 'clickhouse-keyring.asc':
        dir    => '/usr/share/keyrings',
        source => 'https://packages.clickhouse.com/rpm/lts/repodata/repomd.xml.key',
      }

      apt::source { 'clickhouse':
        location => 'https://packages.clickhouse.com/deb',
        release  => 'stable main',
        repos    => '',
        keyring  => '/usr/share/keyrings/clickhouse-keyring.asc',
      }
    }
    'RedHat': {
      yumrepo { 'clickhouse-stable':
        name          => 'clickhouse-stable',
        descr         => 'ClickHouse - Stable Repository',
        baseurl       => 'https://packages.clickhouse.com/rpm/stable/',
        enabled       => 1,
        gpgcheck      => 0,
        repo_gpgcheck => 1,
        gpgkey        => 'https://packages.clickhouse.com/rpm/stable/repodata/repomd.xml.key',
      }
    }
    default: {
      fail("${facts['os']['family']} is not supported (yet).")
    }
  }
}
