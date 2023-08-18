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

    def instructions_map
      {
        "set": proc { |key, value| set(key, value) },
        "get": proc { |key| get(key) },
        "delete": proc { |key| delete(key) }
      }
    end

    def get(key)
      @memtable_handler.read(key)
    end

    def set(key, value)
      @memtable_handler.write(key, value)
    end

    def delete(key)
      @memtable_handler.delete(key)
    end
  end
end
