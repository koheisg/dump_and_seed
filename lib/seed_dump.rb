require 'ipaddr'
require 'seed_dump/dump'
require 'seed_dump/seed_rb'
require 'seed_dump/seed_table'
require 'seed_dump/record'
require 'seed_dump/configuration'

module SeedDump
  require 'seed_dump/railtie' if defined?(Rails)

  def self.configure
    yield(SeedDump::Configuration)
  end
end
