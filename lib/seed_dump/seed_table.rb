module SeedDump
  class SeedTable
    class << self
      def dump_table(records, file)
        io = File.open(file, 'w+')

        return nil if records.count.zero?

        io.write("# frozen_string_literal: true\n\n")

        if table_class_mappings.keys.include?(records.table_name)
          io.write("#{table_class_mappings[records.table_name]}.insert_all!([\n")
        else
          io.write("#{records.table_name.singularize.camelize}.insert_all!([\n")
        end

        records.find_each do |record|
          io.write("  {#{SeedDump::Record.dump_record(record)}},\n")
        end

        io.write("])\n")
      ensure
        io.close if io.present?
      end

      def table_class_mappings
        SeedDump::Configuration.table_class_mappings.with_indifferent_access
      end
    end
  end
end
