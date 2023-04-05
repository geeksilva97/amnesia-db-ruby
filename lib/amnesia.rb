require_relative 'amnesia/query_analyzer'
require_relative 'amnesia/query_parser'

# def set(key, value)
#   File.write('amnesia.txt', "#{key},#{value}\n", mode: 'a+')
#   true
# end

# def get(key)
#   lines = File.readlines('amnesia.txt')

#   result = lines.filter do |line|
#     record_key, = line.split(',', 2)
#     record_key == key
#   end

#   result.last.split(',', 2)[1]
# end

# puts "Welcome to AmnesiaDB - Version 0.0.1\n\n"

# loop do
#   raw_command = gets.delete("\n")

#   break if raw_command == '.exit'

#   map = {
#     "set": proc { |key, value| set(key, value) },
#     "get": proc { |key| get(key) }
#   }
#   instruction_keyword, key, value = raw_command.split(' ')
#   instruction = map[instruction_keyword.to_sym]

#   result = instruction.call(key, value) unless instruction.nil?

#   puts "Result: #{result}\n\n"

#   puts "Unknown command\n\n" if instruction.nil?
# end
