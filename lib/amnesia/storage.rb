module Amnesia
  class Storage
    attr_reader :filename

    def initialize(filename, items: nil)
      @filename = filename
      populate_data(items) unless items.nil? || items.empty?
    end

    def size
      File.size(filename)
    end

    def set(key, value)
      entry = "#{key},#{value}\n"

      File.write(filename, entry, mode: 'a+')
    end

    def all
      File.readlines(filename).map do |record|
        key, value = record.chomp.split(',')

        [key, value]
      end
    end

    def delete(key)
      set(key, '')
    end

    def get(key, index_entry: nil)
      return record_from_index(index_entry) unless index_entry.nil?

      record_from_scan(key)
    end

    def parse_record(raw_record)
      raw_record_value(raw_record)
    end

    def raw_record_value(raw_record)
      (raw_record || '').chomp.split(',', 2)[1]
    end

    def create_db_file(content = '')
      File.write(filename, content) unless file_exists?
    end

    def file_exists?
      File.exist?(filename)
    end

    private

    def populate_data(items)
      data_block = items.map { |(key, value)| "#{key},#{value}\n" }.join('')

      create_db_file(data_block)
    end

    def record_from_scan(key)
      lines = File.readlines(filename)

      record = lines.filter do |line|
        record_key, = line.split(',', 2)
        record_key == key
      end.last

      parse_record(record)
    end

    def record_from_index(index_entry)
      offset, size = index_entry

      record = File.read(filename, size, offset)

      parse_record(record)
    end
  end
end
