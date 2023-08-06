module Amnesia
  class QueryRunner
    def initialize(memtable_handler)
      @memtable_handler = memtable_handler
    end

    def run(instruction_keyword, key, value)
      instruction = instructions_map[instruction_keyword.to_sym]
      instruction.call(key, value)
    end

    private

    def handler
      @memtable_handler
    end

    def instructions_map
      {
        "set": proc { |key, value| set(key, value) },
        "get": proc { |key| get(key) },
        "delete": proc { |key| delete(key) }
      }
    end

    def get(key)
      handler.read(key)
    end

    def set(key, value)
      handler.write(key, value)
    end

    def delete(key)
      handler.delete(key)
    end
  end
end
