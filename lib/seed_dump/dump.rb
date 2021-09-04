# frozen_string_literal: true

module SeedDump
  class Dump
    ACTIVE_RECORD_INTERNAL_TABLES = %w[schema_migrations
                                       ar_internal_metadata].freeze

    def self.dump
      new.dump
    end

    def dump
      before

      seed_rb = SeedDump::SeedRb.new(tables: tables)
      seed_rb.write

      table_and_class_mapper.each do |model, file|
        SeedTable.dump_table(model, file)
      end
    end

    def before
      Rails.application.eager_load!

      FileUtils.mkdir_p seed_dir_path unless Dir.exist?(seed_dir_path)
    end

    def table_and_class_mapper
      tables.map do |table|
        model_class = SeedDump.const_set(table.singularize.camelize.to_sym, Class.new(ActiveRecord::Base))
        model_class.table_name = table

        [model_class, seed_dir_path.join("#{table}.rb")]
      end
    end

    def seed_dir_path
      @seed_dir_path ||= Rails.root.join('db', 'seeds')
    end

    def tables
      ActiveRecord::Base.connection.tables.reject do |table|
        (ACTIVE_RECORD_INTERNAL_TABLES + SeedDump::Configuration.deny_tables).any? {|v| [table].grep(v).present? }
      end
    end
  end
end
