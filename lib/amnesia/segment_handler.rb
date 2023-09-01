module Amnesia
  class SegmentHandler
    def initialize
      @segments = []
      @size_threshold_in_bytes = 40
    end

    def current_segment
      @segments.first
    end

    def segments
      @segments ||= []
    end

    def compact
      segments_to_compact = segments[-2..]

      return if segments_to_compact.nil?

      pp segments_to_compact

      filename = "./_data/#{Time.now.to_i}.c.segment"

      compaction_result = Amnesia::Compactor.call(*segments_to_compact)

      new_segment = Amnesia::Segment.new(filename, items: compaction_result)

      @segments.unshift(new_segment)

      segments.pop(2).each(&:destroy)
    end

    def flush(items)
      create_segment("./_data/#{Time.now.to_i}.segment", items)
      pp 'flushed'
      # TODO: Use the storage class for that
      # filename = "./_data/#{Time.now.to_i}.segment"

      # File.open(filename, 'w') do |f|
      #   items.each { |(key, value)| f.write("#{key},#{value}\n") }
      # end

      # @segments.unshift(Amnesia::Segment.new(filename))

      # compact if @segments.length == 2

      # :finished_flushing
    end

    # TODO: remove this method
    def store(hash_input)
      current_segment.store(hash_input)
    end

    def retrieve(key)
      @segments.each do |segment|
        puts "looking into segment #{segment.name}"

        result = segment.retrieve(key)

        return result unless result.nil?
      end

      nil
    end

    # TODO: remove this method
    def delete(key)
      current_segment.remove(key)
    end

    def populate_index
      current_segment&.populate_index_structure
    end

    def load_segments(filenames)
      puts 'Loading segments...'
      pp filenames

      filenames.each do |filename|
        @segments.unshift(Amnesia::Segment.new(filename))
      end
    end

    private

    def create_segment(filename, items)
      @segments.unshift(Amnesia::Segment.new(filename, items: items))
    end

    def start_segment
      filename = "./_data/#{Time.now.to_i}.segment"

      File.new(filename, 'w').close

      @segments << Amnesia::Segment.new(filename)
    end
  end
end
