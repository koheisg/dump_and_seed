module SeedDump
  class Record
    class << self
      def should_filter?(table, attribute)
        attribute_mapper.dig(table, attribute)
      end

      def filter_colum(table, attribute)
        attribute_mapper[table][attribute].call
      end

      def attribute_mapper
        SeedDump::Configuration.filter_colums.with_indifferent_access
      end

      def dump_record(record)
        record.attributes.map do |attribute, value|
          attribute_mapper.dig(record.class.table_name, attribute).then do |digged|
            if digged
              "#{attribute}: #{attribute_inspect(digged.call)}"
            else
              "#{attribute}: #{attribute_inspect(value)}"
            end
          end
        end.join(', ')
      end

      def attribute_inspect(value)
        if value.nil?
          value.inspect
        else
          if value.is_a?(Date) || value.is_a?(Time)
            %("#{value.to_s(:inspect)}")
          else
            value.inspect
          end
        end
      end
    end
  end
end
