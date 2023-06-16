module Amnesia
  class QueryRunner
    def initialize(segment_handler)
      @segment_handler = segment_handler
    end

    def run(instruction_keyword, key, value)
      instruction = instructions_map[instruction_keyword.to_sym]
      instruction.call(key, value)
    end

    private

    def instructions_map
      {
        "set": proc { |key, value| set(key, value) },
        "get": proc { |key| get(key) },
        "delete": proc { |key| delete(key) }
      }
    end

    def get(key)
      @segment_handler.retrieve(key)
    end

    def set(key, value)
      @segment_handler.store(Hash[key, value])
    end

    def delete(key)
      @segment_handler.delete(key)
    end
  end
end
