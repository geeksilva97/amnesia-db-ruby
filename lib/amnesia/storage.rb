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
      return record_from_index(index_entry, key) unless index_entry.nil?

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

    def record_from_scan(searching_key)
      handler = File.open(filename, 'rb')

      handler.seek(9, IO::SEEK_CUR) # skipping header
      # header = handler.read(9).unpack('CQ') # [num of keys, timestamp]

      # puts 'header of the file'
      # pp header

      result = nil

      until handler.eof?
        block_size, record_size_tombstone, _timestamp, key_size = handler.read(11).unpack('CCQC')

        key = handler.read(key_size)

        if searching_key == key
          is_tombstone = record_size_tombstone & 1

          # value_size = block_size - (key_size + 11 + 1) # 11 ja lidos pra pegar a key, 1 a menos também que é a informacao value_size em si

          # handler.seek(1, IO::SEEK_CUR)

          value_size, = handler.read(1).unpack('C')

          value, = handler.read(value_size).unpack('a*')

          result = "#{key},#{value}\n" # por questoes de compatiblidade

          result = "#{key},\n" if is_tombstone == 1

          break
        else
          # vai para o proximo bloco
          # offset calculado com base no tamanho do bloco subtraidos dos bytes já lidos, 11 + key - numero de bytes da
          # key
          handler.seek(block_size - (key_size + 11), IO::SEEK_CUR)
        end
      end

      handler.close

      parse_record(result)
    end

    def record_from_index(index_entry, key)
      offset, size = index_entry

      # puts "Reading from index -> offset: #{offset} / size -> #{size}"

      value = File.binread(filename, size, offset)

      parse_record("#{key},#{value}\n")
    end
  end
end
