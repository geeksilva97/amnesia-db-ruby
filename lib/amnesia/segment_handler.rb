
module Amnesia
  class SegmentHandler
    def initialize(filename)
      @current_segment = Amnesia::Segment.new(filename)
      # TODO: add @segments list to hold existing segments
      # TODO: add compact method
    end

    def store(hash_input)
      @current_segment.store(hash_input)
    end

    def retrieve(key)
      @current_segment.retrieve(key)
    end

    def delete(key)
      raise 'not implemented yet'
    end

    def populate_index
      @current_segment.populate_index_structure
    end
  end
end
