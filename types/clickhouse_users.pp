# lint:ignore:2sp_soft_tabs
type Clickhouse::Clickhouse_users = Hash[String, Struct[{Optional[password]           => String,
                                                         Optional[quota]              => String,
                                                         Optional[profile]            => String,
                                                         Optional[allow_databases]    => Array[String],
                                                         Optional[networks]           => Clickhouse::Clickhouse_networks,
                                                         Optional[access_management]  => Integer[0,1],
                                                         Optional[grants]             => Array[String],
                                                         Optional[users_dir]          => Stdlib::Unixpath,
                                                         Optional[user_file_owner]    => String,
                                                         Optional[user_file_group]    => String,
                                                         Optional[ensure]             => String}],1]
# lint:endignore
