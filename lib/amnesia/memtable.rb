module Amnesia
  class Memtable
    attr_accessor :status

    def initialize(store = Amnesia::Support::AVL.new)
      @store = store
      @status = :active # active, flushing, finished_flushing
    end

    def size
      @store.size
    end

    def read(key)
      @store.find(key)
    end

    def write(key, value)
      raise 'why are you too dumb?' if @status != :active

      @store.insert(key, value)
    end

    def flush(segment_handler)
      @status = :flushing

      @store.traverse do |node|
        key = node[:key]
        value = node[:value]

        segment_handler.store(Hash[key, value])
      end

      @status = :finished_flushing
    end
  end
end
