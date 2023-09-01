handle = File.open('./_data/sstable.bin')

header = handle.read(13).unpack('CQL')

pp({ num_keys: header[0], created_at: Time.at(header[1]) })

block = handle.read

metadata = block.unpack('CQC') # pega os primeiros 10 bytes

# skippa 10 bytes
key, value_size, value = block.unpack("@10a#{metadata[2]}Ca*")

pp key
pp value_size
pp value

record_size = metadata[0] >> 1 # pegando os primeiros 7 bits
is_tombstone = metadata[0] & 1 # aplicando AND no bit menos significativo

pp block

puts "Record size: #{record_size} / É tombstone? -> #{is_tombstone == 1} / Criado em #{Time.at(metadata[1])}"

handle.close
