module Amnesia
  class MemtableHandler
    def initialize(segment_handler)
      @segment_handler = segment_handler
      @memtables = [Amnesia::Memtable.new]
    end

    def read(key)
    end

    def write(key, value)
    end

    def flush
    end

    private

    def memtable
    end
  end
end
