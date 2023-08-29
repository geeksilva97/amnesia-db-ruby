require_relative 'amnesia/cli'
require_relative 'amnesia/compactor'

dir = './_data'

segment_files = Dir.each_child(dir).map { |f| "#{dir}/#{f}" }.sort_by { |f| File::Stat.new(f).mtime }
# Amnesia::Compactor.call(*segment_files.take(2))

# Thread.new do
#   loop do
#     puts 'I am going to run the compactor from time to time'

#     sleep 10
#   end
# end

Amnesia::CLI.new(segment_files, populate_index: true).start
