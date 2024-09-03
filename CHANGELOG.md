# Changelog

All notable changes to this project will be documented in this file.


## Release 3.0.0 [2024-09-03]

 - BC: replace `clickhouse::params` class by Hiera
 - BC: `clickhouse::server::manage_repo` renamed to `clickhouse::manage_repo`
 - Switch to modern apt GPG keyrings
 - Manage `clickhouse-common-static` package and its version (allow downgrades/upgrades to specific version)

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
