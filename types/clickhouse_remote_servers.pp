# lint:ignore:2sp_soft_tabs, lint:ignore:140chars
type Clickhouse::Clickhouse_remote_servers = Hash[String, Hash[
                                                String,Struct[{
                                                  Optional[weight] => Integer,
                                                  Optional[internal_replication] => Boolean,
                                                  Optional[replication_user]     => String,
                                                  Optional[replication_password] => String,
                                                  Optional[replica]              => Array[Pattern['[^\:]+:[0-9]{1,5}']],
                                                  Optional[replicas]             => Hash[
                                                    String, Struct[{
                                                      Optional[port]             => Integer,
                                                      Optional[priority]         => Integer,
                                                      Optional[secure]           => Integer,
                                                      Optional[default_database] => String,
                                                      Optional[tcp_port_secure]  => Integer,
                                                      Optional[user]             => String,
                                                      Optional[password]         => String,
                                                    }]
                                                  ]
                                                }]
                                              ]
                                            ]
# lint:endignore
