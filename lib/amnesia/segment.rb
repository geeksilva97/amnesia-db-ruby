module Amnesia
  class Segment
    attr_reader :index_structure

    def initialize(filename, items: nil, index_structure: Amnesia::Indexes::HashIndex.new)
      @filename = filename
      @storage = Amnesia::Storage.new(filename, items: items)
      @storage.create_db_file unless @storage.file_exists?
      @index_structure = index_structure
    end

    def name
      @filename
    end

    def destroy
      File.delete(@filename)
    end

    def all
      @storage.all
    end

    def retrieve(key)
      index_entry = @index_structure.get(key)

      @storage.get(key, index_entry: index_entry)
    end

    def size
      @storage.size
    end

    def remove(key)
      offset = @storage.delete(key)
      @index_structure.add(key, [size, size + offset - 1])
      1
    end

    def store(hash_input)
      key, value = hash_input.entries.first
      record = "#{key},#{value}\n"
      offset = @storage.size

      @index_structure.add(key, [offset, record.bytesize - 1])

      @storage.set(key, value)
    end

    def populate_index_structure
      fd = File.open(@storage.filename, 'rb')

      fd.seek(9, IO::SEEK_CUR) # skipping header

      until fd.eof?
        _block_size, _record_size_tombstone, _timestamp, key_size = fd.read(11).unpack('CCQC')
        record_key = fd.read(key_size)

        value_size, = fd.read(1).unpack('C')

        puts "Adding index entry\nKey -> #{record_key}\nFile offset -> #{fd.pos}\nValue size -> #{value_size}"

        @index_structure.add(record_key, [fd.pos, value_size])

        fd.seek(value_size, IO::SEEK_CUR)
      end

      pp @index_structure

      fd.close
    end
  end
end
