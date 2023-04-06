module Amnesia
  class QueryParser
    def self.call(raw_command)
      tokens = raw_command.split(' ')
      puts tokens

      raise 'Unable to parse command' if tokens.size > 3 || tokens.size < 2

      instruction, *rest = tokens

      [instruction.downcase, *rest]
    end
  end
end
