# lint:ignore:2sp_soft_tabs
type Clickhouse::Clickhouse_replication = Struct[{zookeeper_servers => Array[Pattern['[^\:]+:[0-9]{1,5}']],
                                                  Optional[macros]  => Hash[String, Any],
                                                  Optional[distributed_ddl] => Struct[{
                                                      Optional[path] => String,
                                                      Optional[profile] => String,
                                                    }]
                                                  }]
# lint:endignore
