require "jennifer"
require "jennifer/adapter/postgres"

Jennifer::Config.configure do |conf|
  conf.host = "database"
  conf.user = "postgres"
  conf.password = "postgres"
  conf.adapter = "postgres"
  conf.db = "rinha_crystal"
  # conf.migration_files_path = "./any/path/migrations"
  conf.pool_size = 30
  conf.logger.level = :error
end

# Log.setup "db", :debug, Log::IOBackend.new(formatter: Jennifer::Adapter::DBFormatter)
