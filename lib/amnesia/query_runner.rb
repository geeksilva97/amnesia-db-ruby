module Amnesia
  class QueryRunner
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
      "Getting key #{key}"
    end

    def set(key, value)
      "Setting key #{key} to value #{value}"
    end
  end
end
