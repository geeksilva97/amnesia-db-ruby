module Amnesia
  class Storage
    attr_reader :filename

    FIXED_AMOUNT_OF_BYTE_PER_BLOCK = 12

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
      num_keys = items.length
      creation_timestamp = Time.now.to_i

      header = [num_keys, creation_timestamp].pack('CQ')

      data_blocks = items.map do |(key, value)|
        is_tombstone = value.empty? ? 1 : 0
        key_size = key.bytesize
        value_size = value.bytesize
        record_size = key_size + value_size
        record_size_tombstone_composition = (record_size << 1) | is_tombstone

        block_size = FIXED_AMOUNT_OF_BYTE_PER_BLOCK + record_size

        row = [block_size, record_size_tombstone_composition, creation_timestamp, key_size, key, value_size, value]

        row.pack("CCQCa#{key_size}Ca#{value_size}")
      end.join

      File.binwrite(filename, "#{header}#{data_blocks}")

      # create_db_file(data_block)
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
