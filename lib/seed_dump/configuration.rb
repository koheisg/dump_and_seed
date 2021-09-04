# frozen_string_literal: true

require 'active_support/core_ext'

module SeedDump
  class Configuration
    class_attribute :deny_tables, default: []
    class_attribute :table_class_mappings, default: {}
    class_attribute :filter_colums, default: {}
  end
end
