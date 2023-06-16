module Amnesia::Indexes
  class HashIndex
    def initialize
      @entries = {}
    end

    def add(index_key, index_value)
      @entries[index_key] = index_value
    end

    def get(index_key)
      @entries[index_key]
    end
  end
end
