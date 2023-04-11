require_relative 'amnesia/cli'

database_filename = ARGV[0]

raise 'you must select the database filename' if database_filename.nil?

Amnesia::CLI.new(database_filename).start
