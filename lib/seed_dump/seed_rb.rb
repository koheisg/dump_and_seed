module SeedDump
  class SeedRb
    def initialize(tables:)
      @stack = []
      @tables = tables
    end

    def sort_table
      until @tables.size.zero? do
        @tables.each do |table|
          if ActiveRecord::Base.connection.foreign_keys(table).map(&:to_table).all? { |table| @stack.include?(table) }
            @stack << table
          end
        end
        @tables -= @stack
      end

      @stack
    end

    def write
      seed_rb = Rails.root.join('db', 'seeds.rb')
      io = File.open(seed_rb, 'w+')
      io.write("# frozen_string_literal: true\n")
      io.write("\n")

      sort_table.each do |table|
        io.write "load(Rails.root.join('db','seeds','#{table}.rb'))\n"
      end

      io.write("\n")
      io.write('con = ActiveRecord::Base.connection')
      io.write("\n")
      io.write('%w[' + sort_table.join("\n  ")+ '].each do |table_name|')
      io.write("\n")
      io.write('  con.execute(<<~SQL)')
      io.write("\n")
      io.write('    select setval(\'#{table_name}_id_seq\', (select max(id) from #{table_name}))')
      io.write("\n")
      io.write('  SQL')
      io.write("\n")
      io.write('end')
      io.write("\n")
    ensure
      io.close if io.present?
    end
  end
end
