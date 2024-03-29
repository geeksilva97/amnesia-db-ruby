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
      lines = File.readlines(@storage.filename)
      byte_offset = 0

      lines.each do |line|
        record_key, = line.split(',', 2)
        record_size = line.bytesize

        @index_structure.add(record_key, [byte_offset, record_size - 1])

        byte_offset += line.bytesize
      end
    end
  end
end
