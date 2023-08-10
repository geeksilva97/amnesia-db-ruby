module Amnesia
  class MemtableHandler
    def initialize(segment_handler, max_items_threshold = 5)
      @segment_handler = segment_handler
      @max_items_threshold = max_items_threshold

      # Boa escolha?
      @memtables = [Amnesia::Memtable.new]
    end

    def read(key); end

    def write(key, value)
      available_memtable = @memtables.detect { |memtable| memtable.status == :active }

      available_memtable.write(key, value)

      flush if available_memtable.size >= @max_items_threshold
    end

    def delete(key)
      write(key, '')
    end

    private

    def flush
      current_memtable = memtable

      @memtables.push(Amnesia::Memtable.new)

      current_memtable.flush(@segment_handler)

      @memtables.shift
    end

    def memtable
      @memtables.first
    end
  end
end
