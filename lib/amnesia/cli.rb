require_relative './query_parser'
require_relative './query_analyzer'
require_relative './query_runner'
require_relative './segment'
require_relative './segment_handler'
require_relative './storage'
require_relative './indexes/hash_index'

module Amnesia
  class CLI
    def initialize(filename, populate_index: nil)
      @segment_handler = Amnesia::SegmentHandler.new(filename)
      @segment_handler.populate_index if populate_index
    end

    def start
      puts "Welcome to AmnesiaDB - Version 0.1.0\n\n"

      loop do
        raw_command = read_user_input

        break if raw_command == '.exit'

        start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

        instruction_keyword, key, value = Amnesia::QueryParser.call(raw_command)

        next if analysis_failed?(instruction_keyword, key, value)

        result = query_runner.run(instruction_keyword, key, value)

        end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

        puts "#{result}\n\n"
        puts "Executed in #{end_time - start_time} sec"
      end
    end

    private

    def query_runner
      @query_runner ||= Amnesia::QueryRunner.new(@segment_handler)
    end

    def read_user_input
      print '> '
      $stdin.gets.delete("\n")
    end

    def analysis_failed?(instruction_keyword, key, value)
      Amnesia::QueryAnalyzer.call!(instruction_keyword, key, value)
    rescue RuntimeError => e
      puts "Error: #{e}\n\n"
      true
    end
  end
end
