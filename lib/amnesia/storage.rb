module Amnesia
  class Storage
    attr_reader :filename

    def initialize(filename)
      @filename = filename
    end

    def size
      File.size(filename)
    end

    def set(key, value)
      entry = "#{key},#{value}\n"

      File.write(filename, entry, mode: 'a+')
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

    def create_db_file
      File.write(filename, '') unless file_exists?
    end

    def file_exists?
      File.exist?(filename)
    end

    private

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
