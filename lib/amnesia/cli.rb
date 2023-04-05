require_relative './query_parser'
require_relative './query_runner'

module Amnesia
  class CLI
    def start
      loop do
        puts "Welcome to AmnesiaDB - Version 0.0.1\n\n"
        raw_command = gets.delete("\n")

        break if raw_command == '.exit'

        instruction_keyword, key, value = Amnesia::QueryParser.call(raw_command)

        #         if instruction.nil?
        #           puts "Unknown command\n\n"
        #           next
        #         end

        result = Amnesia::QueryRunner.call(instruction_keyword, key, value)

        puts "#{result}\n\n"
      end
    end
  end
end
