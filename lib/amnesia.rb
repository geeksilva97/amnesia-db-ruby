require_relative 'amnesia/cli'

dir = './_data'

segment_files = Dir.each_child(dir).map { |f| "#{dir}/#{f}" }.sort_by { |f| File::Stat.new(f).mtime }

Amnesia::CLI.new(segment_files, populate_index: true).start
