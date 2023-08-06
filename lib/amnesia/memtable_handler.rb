module Amnesia
  class MemtableHandler
    def initialize(segment_handler)
      @segment_handler = segment_handler
      @memtables = [Amnesia::Memtable.new]
    end

    def read(key)
      memtable.read(key)
    end

    def write(key, value)
      memtable.write(key, value)
    end

    def flush
      memtable.status = :flushing
      memtable.flush(segment_handler)
      memtable.status = :finished_flusing
    end

    private

    def memtable
      @memtables.first
    end
  end
end
