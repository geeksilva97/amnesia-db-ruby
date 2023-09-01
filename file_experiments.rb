handle = File.open('./_data/sstable.bin')

num_keys, timestamp = handle.read(13).unpack('CQL')

data_blocks = handle.read
seek = 0

# the layout is bad. Ruby does not know how to unpack variable Data
# with slice we can skip bytes

0.upto(num_keys - 1) do |index|
  record_size_tombstone_flag, timestamp, key_size, value_size = data_blocks.unpack("@#{seek}CQCC")

  seek += 11

  record_size = record_size_tombstone_flag >> 1 # pegando os primeiros 7 bits
  is_tombstone = record_size_tombstone_flag & 1 # aplicando AND no bit menos significativo

  key, value = data_blocks.unpack("@#{seek}a#{key_size}a#{value_size}")

  seek += key_size + value_size

  puts "#{index} Record details\n\nTombstone? -> #{is_tombstone == 1}\nKey -> #{key}\nKey Size ->#{key_size}\nValue size-> #{value_size}\nValue ->#{value}\nRecord size -> #{record_size}\n"
end

# seek += value_size + 8

# pp value

# 0.upto(num_keys - 1) do |index|
#   puts "looking for record #{index}"
#   record_size_tombstone_flag, timestamp, key_size = data_blocks.unpack("@#{seek}CQC")

#   record_size = record_size_tombstone_flag[0] >> 1 # pegando os primeiros 7 bits
#   is_tombstone = record_size_tombstone_flag[0] & 1 # aplicando AND no bit menos significativo

#   seek += 10

#   key = data_blocks.unpack("@#{seek}a#{key_size}")

#   seek += key_size # incrementa a quantidade de bytes lidos para o valor da key

#   puts "\nRecord size -> #{record_size_tombstone_flag}\nKey -> #{key}\nTombstone? -> #{is_tombstone == 1}"
#   puts ''
# end

# metadata = block.unpack('CQC') # pega os primeiros 10 bytes

# # skippa 10 bytes
# # senti fala de uma snynaxe como a do perl. seria bem mais util no unpacking de dadoa variaveis
# key, value_size, value = block.unpack("@10a#{metadata[2]}Ca*")

# pp key
# pp value_size
# pp value

# record_size = metadata[0] >> 1 # pegando os primeiros 7 bits
# is_tombstone = metadata[0] & 1 # aplicando AND no bit menos significativo

# pp block

# puts "Record size: #{record_size} / É tombstone? -> #{is_tombstone == 1} / Criado em #{Time.at(metadata[1])}"

# handle.close
