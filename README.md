# Puppet Clickhouse

[![Puppet Forge](http://img.shields.io/puppetforge/v/deric/clickhouse.svg)](https://forge.puppet.com/modules/deric/clickhouse) [![Tests](https://github.com/deric/puppet-clickhouse/actions/workflows/spec.yml/badge.svg)](https://github.com/deric/puppet-clickhouse/actions/workflows/spec.yml)

The clickhouse module installs, configures and manages the Clickhouse Server service.

It also allows to create and manage users, quotas, profiles, dictionaries, databases as well as configure replication and sharding.

## Setup

### Setup Requirements

This module requires xml-simple gem, which is used to translate Hash configuration to Clickhouse XML format configuration files.
To install it you need to execute following command on your puppetmaster server:

```bash
sudo puppetserver gem install xml-simple
```

### Beginning with clickhouse

To install a server with the default options:

`include 'clickhouse::server'`.

To customize Clickhouse server options, you must also pass in an override hash:

```puppet
class { 'clickhouse::server':
  override_options => $override_options
}
```

See [**Customize Server Options**](#customize-server-options) below for examples of the hash structure for $override_options.

## Usage

All server configuration is done via `clickhouse::server`. To install client separatly, use `clickhouse::client`

### Customize server options

To define server options, pass a hash structure of overrides in `clickhouse::server`. Server configuration parameters can be found at https://clickhouse.yandex/docs/en/operations/server_settings/settings/

```puppet
$override_options = {
  parent_xml_tag => {
    item => thing,
  }
}
```

For example, to configure zstd compression pass following override options hash:

```puppet
$override_options = {
  compression => {
    case => {
      min_part_size       => 10000000000,
      min_part_size_ratio => 0.01,
      method              => 'zstd',
    }
  }
}
```
It will add following section to Clickhouse configuration file:

```xml
<compression>
    <case>
        <min_part_size>10000000000</min_part_size>
        <min_part_size_ratio>0.01</min_part_size_ratio>
        <method>zstd</method>
    </case>
</compression>
```

### Create a database

To create a database:

```puppet
clickhouse_database { 'my_database':
  ensure => 'present',
}
```

### Specify passwords for users

In addition to passing passwords in plain text, you can input them in sha256 encoding. For example:

```puppet
class { 'clickhouse::server':
  users => {
    myuser => {
      password => '02472d6a1e23f73b37481bbd67949a5d16cbaf3d71770696f20a0cd773a2e682',
    }
  }
}
```

### Install Clickhouse Server

This example shows how to install Clickhouse Server, configure zstd compression for it, create production profile and quota, create user alice and assign production profile and quota to her and also configure replication and three different sharding schemas: replicated - just a basic replication with single shard and two replicas; segmented - two shards without replicas; segmented_replicated - two shards each having two replicas:

```puppet
class { 'clickhouse::server':
  override_options => {
    compression => {
      case => {
        min_part_size       => 10000000000,
        min_part_size_ratio => 0.01,
        method              => 'zstd',
      },
    },
  },
  profiles         => {
    production => {
      use_uncompressed_cache => 0,
      log_queries => 1,
      max_memory_usage => ceiling($facts['memory']['system']['total_bytes'] * 0.7),
    },
  },
  quotas           => {
    production => {
      interval => [
        {
          duration       => 3600,
          queries        => 200,
          erros          => 10,
          result_rows    => 0,
          read_rows      => 0,
          execution_time => 0,
        }
      ],
    },
  },
  users            => {
    alice => {
      password => '02472d6a1e23f73b37481bbd67949a5d16cbaf3d71770696f20a0cd773a2e682',
      quota    => 'production',
      profile  => 'production',
      network  => {
        ip => ['::/0'],
      },
    },
  },
  replication      => {
    zookeeper_servers => ['zookeeper1.local:2181', 'zookeeper2.local:2181', 'zookeeper3.local:2181'],
    macros => {
      cluster => 'Clickhouse_cluster',
      replica => $facts['networking']['fqdn'],
    },
  },
  remote_servers   => {
    replicated           => {
      shard => {
        internal_replication => true,
        replica              => ['host1.local:9000', 'host2.local:9000'],
      },
    },
    segmented            => {
      shard1 => {
        weight               => 1,
        internal_replication => true,
        replica              => ['host1.local:9000'],
      },
      shard2 => {
        weight               => 2,
        internal_replication => true,
        replica              => ['host2.local:9000'],
      },
    },
    segmented_replicated => {
      shard1 => {
        internal_replication => true,
        replica              => ['host1.local:9000', 'host2.local:9000'],
      },
      shard2 => {
        internal_replication => true,
        replica              => ['host3.local:9000', 'host4.local:9000'],
      },
    },
  },
}
```

### Hiera support

Configuration from YAML backend:
```yaml
clickhouse::server::override_options:
  listen_host: 0.0.0.0
  default_profile: default
  default_database: default
  mark_cache_size: 5368709120
  uncompressed_cache_size: 8589934592
  path: /var/lib/clickhouse/
  interserver_http_port: 9009
  interserver_http_host: "%{::fqdn}"
  max_connections: 4096
  max_concurrent_queries: 100
  http_port: 8123
  tcp_port: 9000
  prometheus:
    endpoint: /metrics
    port: 8001
    metrics: true
    events: true
    asynchronous_metrics: true
clickhouse::server::profiles:
  default:
    max_memory_usage: 10000000000 #  Maximum memory usage for processing single query, in bytes
    use_uncompressed_cache: 0 # Use cache of uncompressed blocks of data. Meaningful only for processing many of very short queries
    load_balancing: random
  readonly:
    readonly: 1
```


### Replicas

Configure host properties:
```yaml
clickhouse::server::remote_servers:
  replicated:
    shard:
      internal_replication: true
      replicas:
        host1.local:
          port: 9000
          priority: 1
          default_database: foo
          tcp_port_secure: 9100
          secure: 1
          user: click
          password: house
        host2.local:
          port: 9000
```

### Crash reports

Settings for opt-in sending crash reports.

```
clickhouse::server::crash_reports:
  enabled: true
  endpoint: http://sentry.localhost # Overrides the Sentry endpoint
  debug: false
```


## Reference

**Classes**

_Public Classes_

* [`clickhouse::client`](./REFERENCE.md#clickhouseclient): Installs and configures Clickhouse client.
* [`clickhouse::repo`](./REFERENCE.md#clickhouserepo): Installs repository for Clickhouse.
* [`clickhouse::server`](./REFERENCE.md#clickhouseserver): Installs and configures Clickhouse server.

_Private Classes_

* `clickhouse::client::install`: Private class for managing Clickhouse client package.
* `clickhouse::params`: Private class for setting default Clickhouse parameters.
* `clickhouse::server::config`: Private class for Clickhouse server configuration.
* `clickhouse::server::install`: Private class for managing Clickhouse server package.
* `clickhouse::server::resources`: Private class for applying Clickhouse resources.
* `clickhouse::server::service`: Private class for managing the Clickhouse service.

**Defined types**

* [`clickhouse::server::dictionary`](./REFERENCE.md#clickhouseserverdictionary): Create and manage Clickhouse dictionary.
* [`clickhouse::server::macros`](./REFERENCE.md#clickhouseservermacros): Create and manage Clickhouse macros file for replication.
* [`clickhouse::server::profiles`](./REFERENCE.md#clickhouseserverprofiles): Create and manage Clickhouse profiles.
* [`clickhouse::server::quotas`](./REFERENCE.md#clickhouseserverquotas): Create and manage Clickhouse quotas.
* [`clickhouse::server::remote_servers`](./REFERENCE.md#clickhouseserverremote_servers): Create and manage Clickhouse remote servers for Distributed engine.
* [`clickhouse::server::user`](./REFERENCE.md#clickhouseserveruser): Create and manage Clickhouse user.

**Resource types**

* [`clickhouse_database`](./REFERENCE.md#clickhouse_database): Manages a Clickhouse database.

**Functions**

* [`clickhouse_config`](./REFERENCE.md#clickhouse_config): Convert hash to Clickhouse XML config.

## Limitations

For a list of supported operating systems, see [metadata.json](https://github.com/MaxFedotov/puppet-clickhouse/blob/master/metadata.json)

## Development

Please feel free to fork, modify, create issues, bug reports and pull requests.

### Testing epp templates

Render template from CLI:
```
$ puppet epp render templates/zookeeper.xml.epp --values "{'zookeeper_servers' => ['172.0.0.1:2181'], distributed_ddl=> {path => '/foo' }}"
```
