# lint:ignore:2sp_soft_tabs
type Clickhouse::Clickhouse_crash_reports = Struct[{enabled => Boolean,
                                                  Optional[endpoint]  => String,
                                                  Optional[anonymize] => Boolean,
                                                  Optional[http_proxy] => String,
                                                  Optional[debug] => Boolean,
                                                  Optional[tmp_path] => String
                                                  }]
# lint:endignore