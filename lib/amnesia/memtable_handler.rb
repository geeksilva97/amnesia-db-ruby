module Amnesia
  class MemtableHandler
    def initialize(segment_handler, max_items_threshold = 1)
      @segment_handler = segment_handler
      @max_items_threshold = max_items_threshold

      # Boa escolha?
      @memtables = [Amnesia::Memtable.new]
    end

    def read(key)
      record = find_key_in_memtables(key)

      # se estiver na memtable já retorna
      return record.value unless record.nil?

      # Busca no disco
      @segment_handler.retrieve(key)
    end

    def write(key, value)
      available_memtable = @memtables.detect { |memtable| memtable.status == :active }

      available_memtable.write(key, value)

      flush if available_memtable.size >= @max_items_threshold
    end

    def delete(key)
      write(key, '')
    end

    private

    def find_key_in_memtables(key)
      @memtables.each do |table|
        result = table.read(key)

        return result unless result.nil?
      end

      nil
    end

    def flush
      current_memtable = memtable

      @memtables.unshift(Amnesia::Memtable.new)

      current_memtable.flush(@segment_handler)

      @memtables.pop

      'flushed'
    end

    def memtable
      @memtables.first
    end
  end
end
