module Amnesia
  class Segment
    def initialize(filename, index_structure: nil)
      @storage = Amnesia::Storage.new(filename)
      @storage.create_db_file unless @storage.file_exists?
    end

    def retrieve(key)
      @storage.get(key)
    end

    def store(hash_input)
      @storage.set(*hash_input.entries.first)
    end
  end
end
