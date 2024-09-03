# @summary
#   Installs and configures Clickhouse
#
# @param manage_repo
#   Whether to install Clickhouse repository.
class clickhouse (
  Boolean $manage_repo,
) {
  if $manage_repo {
    include clickhouse::repo
  }
}
