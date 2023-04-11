module Amnesia
  class Storage
    def initialize(filename)
      @filename = filename
      @index_structure = {}
    end

    def set(key, value)
      offset = File.size(filename)
      entry = "#{key},#{value}\n"

      @index_structure[key] = [offset, entry.bytesize - 1]

      File.write(filename, entry, mode: 'a+')
    end

    def get(key)
      index_entry = @index_structure[key]

      return record_from_index(index_entry) unless index_entry.nil?

      record_from_scan(key)
    end

    def record_from_scan(key)
      lines = File.readlines(filename)

      record = lines.filter do |line|
        record_key, = line.split(',', 2)
        record_key == key
      end.last

      parse_record(record) unless record.nil?
    end

    def record_from_index(index_entry)
      offset, size = index_entry

      record = File.read(filename, size, offset)

      parse_record(record) unless record.nil?
    end

    def parse_record(raw_record)
      raw_record.split(',', 2)[1]
    end

    def create_db_file
      File.write(filename, '') unless file_exists?
    end

    def file_exists?
      File.exist?(filename)
    end

    private

    attr_reader :filename
  end
end
