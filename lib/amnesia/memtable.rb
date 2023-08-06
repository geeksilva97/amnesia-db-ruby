module Amnesia
  class Memtable
    attr_accessor :status

    def initialize
      @store = Amnesia::Support::AVL.new
      @status = :active
    end

    def read(key)
      @store.find(key)
    end

    def write(key, value)
      @store.insert(key, value)
    end

    def flush(segment_handler)
      # TODO: Write a whole block
      @store.traverse { |node| segment_handler.store({ key: node.key, value: node.value }) }
    end
  end
end
