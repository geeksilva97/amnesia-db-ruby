module Amnesia
  class QueryParser
    def self.call(raw_command)
      tokens = raw_command.split(' ')

      raise 'Unable to parse command' if tokens.size > 3

      tokens
    end
  end
end
