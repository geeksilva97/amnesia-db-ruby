module Amnesia
  class Memtable
    attr_accessor :status

    def initialize
    end

    def read(key)
    end

    def write(key, value)
    end

    def flush(segment_handler)
    end
  end
end
