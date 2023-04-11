require_relative './query_parser'
require_relative './query_analyzer'
require_relative './query_runner'
require_relative './storage'

module Amnesia
  class CLI
    def initialize(filename)
      @amnesia_storage = Amnesia::Storage.new(filename)
      @amnesia_storage.create_db_file unless @amnesia_storage.file_exists?
    end

    def start
      query_runner = Amnesia::QueryRunner.new(@amnesia_storage)
      puts "Welcome to AmnesiaDB - Version 0.0.1\n\n"

      loop do
        print '> '
        raw_command = $stdin.gets.delete("\n")

        break if raw_command == '.exit'

        instruction_keyword, key, value = Amnesia::QueryParser.call(raw_command)

        next if analysis_failed?(instruction_keyword, key, value)

        result = query_runner.run(instruction_keyword, key, value)

        puts "#{result}\n\n"
      end
    end

    private

    def analysis_failed?(instruction_keyword, key, value)
      Amnesia::QueryAnalyzer.call!(instruction_keyword, key, value)
    rescue RuntimeError => e
      puts "Error: #{e}\n\n"
      true
    end
  end
end
