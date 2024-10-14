# Changelog

All notable changes to this project will be documented in this file.

## Release 3.1.0 [2024-10-14]

- feat(users): add options for user management (#3)

[Full changes](https://github.com/deric/puppet-clickhouse/compare/v3.0.0...v3.1.0)

## Release 3.0.0 [2024-09-03]

 - BC: replace `clickhouse::params` class by Hiera
 - BC: `clickhouse::server::manage_repo` renamed to `clickhouse::manage_repo`
 - Feat: switch to modern apt GPG keyrings
 - Feat: Manage `clickhouse-common-static` package and its version (allow downgrades/upgrades to specific version)
 - BC: removed `clickhouse::server::client_*` parameters, all are remain available via `clickhouse::client::*` namespace
 - Remove support for old systems
 - Ensure correct resources ordering

[Full changes](https://github.com/deric/puppet-clickhouse/compare/v2.1.0...v3.0.0)

## Release 2.1.0 [2024-06-28]

 - Feat: add secure option to use ssl on keeper communications
 - Fix: declare client variables on server to be passed on client class instantiation
 - Fix: invalid yaml data


## Release 2.0.0 [2024-02-14]

 - Support Puppet 8
 - puppetlabs/stdlib 9
 - puppetlabs/apt 9
 - Removed anchors, using contain instead
 - Use official RPM repo

## Release 1.2.0

  - Switched apt to packages.clickhouse.com

**Bugfixes**

  - Fixed apt dependency cycle

## Release 1.1.0
