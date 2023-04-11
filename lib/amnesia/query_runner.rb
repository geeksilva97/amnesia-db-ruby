module Amnesia
  class QueryRunner
    def initialize(amnesia_storage)
      @amnesia_storage = amnesia_storage
    end

    def run(instruction_keyword, key, value)
      instruction = instructions_map[instruction_keyword.to_sym]
      instruction.call(key, value)
    end

    private

    def instructions_map
      {
        "set": proc { |key, value| set(key, value) },
        "get": proc { |key| get(key) }
      }
    end

    def get(key)
      @amnesia_storage.get(key)
    end

    def set(key, value)
      @amnesia_storage.set(key, value)
    end
  end
end
