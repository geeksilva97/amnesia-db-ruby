module Amnesia
  class QueryAnalyzer
    def self.call!(instruction, key, _value)
      raise 'unknown instruction' unless instruction_grammar.include? instruction
      raise 'malformed key' unless key_valid?(key)
    end

    def self.instruction_grammar
      %w[set get delete]
    end

    def self.key_valid?(key)
      /^[a-zA-Z]+[0-9A-Za-z:_]*$/.match?(key)
    end
  end
end
