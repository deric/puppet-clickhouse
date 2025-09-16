# Puppet provider for clickhouse
class Puppet::Provider::Clickhouse < Puppet::Provider
  # Without initvars commands won't work.
  initvars

  # Make sure we find clickhouse commands
  ENV['PATH'] = ENV['PATH'] + ':/usr/libexec:/usr/local/libexec:/usr/local/bin'

  # rubocop:disable Style/HashSyntax
  commands :clickhouse_raw => 'clickhouse-client'

  def self.clickhouse_caller(text_of_sql)
    opts = []
    if File.file?('/root/.clickhouse-client/config.xml')
      opts = ['-c', '/root/.clickhouse-client/config.xml']
    elsif File.file?('/root/.clickhouse-client/config.yml')
      opts = ['-c', '/root/.clickhouse-client/config.yml']
    end
    opts.push('-q')
    opts.push(text_of_sql)
    clickhouse_raw(opts.flatten.compact)
  end
end
