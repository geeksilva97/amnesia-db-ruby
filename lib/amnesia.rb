require_relative 'amnesia/cli'

database_filename = ARGV[0]
populate_index = true if ARGV[1] == '--populate-index'

raise 'you must select the database filename' if database_filename.nil?

Amnesia::CLI.new(database_filename).start(populate_index: populate_index)
