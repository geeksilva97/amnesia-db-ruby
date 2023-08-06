module Amnesia
  class MemtableHandler
    def initialize(segment_handler, max_items_threshold = 5)
      @max_items_threshold = max_items_threshold
      @segment_handler = segment_handler
      @memtables = [Amnesia::Memtable.new] # maybe it can be a linked list
    end

    def read(key)
      memtable = @memtables.reverse_each.detect { |table| table.read(key) }

      result = memtable.read(key) unless memtable.nil?

      return "#{result.key},#{result.value}" unless result.nil?

      @segment_handler.retrieve(key)
    end

    def delete(key)
      write(key, '')
    end

    def write(key, value)
      available_memtable = @memtables.detect { |memtable| memtable.status == :active }

      available_memtable.write(key, value)

      flush if available_memtable.size >= @max_items_threshold
    end

    def flush
      current_memtable = memtable
      @memtables.push(Amnesia::Memtable.new)
      current_memtable.flush(@segment_handler)
      @memtables.shift
    end

    private

    def memtable
      @memtables.first
    end
  end
end
