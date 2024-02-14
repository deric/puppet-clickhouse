# @summary
#   Private class for managing the Clickhouse service.
#
# @api private
#
class clickhouse::server::service {
  if $clickhouse::server::manage_service {
    service { $clickhouse::server::service_name:
      ensure => $clickhouse::server::service_ensure,
      enable => $clickhouse::server::service_enabled,
    }

    if $clickhouse::server::manage_package {
      Service[$clickhouse::server::service_name] {
        require => Package[$clickhouse::server::package_name],
      }
    }

    if $clickhouse::server::manage_config {
      File["${clickhouse::server::main_dir}/${clickhouse::server::config_file}"] -> Service[$clickhouse::server::service_name]
      Service<| title == $clickhouse::server::service_name |> {
        subscribe => File["${clickhouse::server::main_dir}/${clickhouse::server::config_file}"],
      }
    }

    if $clickhouse::server::manage_systemd {
      file { '/etc/systemd/system/clickhouse-server.service':
        owner     => 'root',
        group     => 'root',
        mode      => '0664',
        content   => epp("${module_name}/server_systemd.epp", {
            'config' => "${clickhouse::server::main_dir}/${clickhouse::server::config_file}",
            'user'   => $clickhouse::server::clickhouse_user,
            'group'  => $clickhouse::server::clickhouse_group,
        }),
        notify    => Exec['reload-systemd'],
        subscribe => File['/etc/default/clickhouse-server'],
      }

      file { '/etc/default/clickhouse-server':
        owner   => $clickhouse::server::clickhouse_user,
        group   => $clickhouse::server::clickhouse_group,
        mode    => '0664',
        content => epp("${module_name}/server_env.epp", {
            'config' => "${clickhouse::server::main_dir}/${clickhouse::server::config_file}",
        }),
      }

      exec { 'reload-systemd':
        command     => 'systemctl daemon-reload',
        refreshonly => true,
        path        => '/bin:/usr/bin:/usr/local/bin',
      }
    }
  }
}
