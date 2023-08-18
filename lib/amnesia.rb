require_relative 'amnesia/cli'

# database_filename = ARGV[0]
# populate_index = true if ARGV[1] == '--populate-index'

# raise 'you must select the database filename' if database_filename.nil?

dir = './_data'

segment_files = Dir.each_child(dir).map { |f| "#{dir}/#{f}" }.sort_by { |f| File::Stat.new(f).mtime }

Amnesia::CLI.new(segment_files, populate_index: true).start
