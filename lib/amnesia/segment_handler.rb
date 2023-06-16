module Amnesia
  class SegmentHandler
    def initialize(filename)
      @current_segment = Amnesia::Segment.new(filename)
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
  end
end
