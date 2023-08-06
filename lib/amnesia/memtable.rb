module Amnesia
  class Memtable
    attr_accessor :status

    def initialize(store = Amnesia::Support::AVL.new)
      @store = store
      @status = :active
    end

    def size
      @store.size
    end

    def read(key)
      @store.find(key)
    end

    def write(key, value)
      @store.insert(key, value)
    end

    def flush(segment_handler)
      # TODO: Write a whole block instead of each node be a write
      @status = :flushing
      @store.traverse { |node| segment_handler.store({ key: node[:key], value: node[:value] }) }
      @status = :finished_flusing
    end
  end
end
