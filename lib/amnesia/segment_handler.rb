module Amnesia
  class SegmentHandler
    def initialize
      @segments = []
      @size_threshold_in_bytes = 50
    end

    def current_segment
      start_segment if @segments.empty?

      @segments.first
    end

    def store(hash_input)
      current_segment.store(hash_input)
    end

    def retrieve(key)
      current_segment.retrieve(key)
    end

    def delete(key)
      current_segment.remove(key)
    end

    def populate_index
      current_segment.populate_index_structure
    end

    def load_segments(filenames)
      puts 'Loading segments...'
      pp filenames

      filenames.each do |filename|
        @segments << Amnesia::Segment.new(filename)
      end
    end

    private

    def start_segment
      filename = "./_data/#{Time.now.to_i}.segment"

      File.new(filename, 'w').close

      @segments << Amnesia::Segment.new(filename)
    end
  end
end
