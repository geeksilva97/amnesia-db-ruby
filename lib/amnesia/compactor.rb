module Amnesia
  class Compactor
    def self.call(sstable1, sstable2)
      # todos itens de sstable1 e sstable2
      sstable_items1 = sstable1.all
      sstable_items2 = sstable2.all

      pp sstable_items1
      pp sstable_items2

      puts ''

      # ponteiro 1, ponteiro 2 -> 0
      p1 = p2 = 0

      result = []

      # loop ate que eu termine os registros de ambos os arquivos
      loop do
        item1 = sstable_items1[p1] # item é uma tupla ['name', 'mateus']
        item2 = sstable_items2[p2]

        break if item1.nil? && item2.nil?

        # TODO: o que acontece se uma das keys for nil ?
        key1 = item1[0] unless item1.nil?
        key2 = item2[0] unless item2.nil?

        min_key = [key1, key2].compact.min

        if key1 == key2
          p1 += 1
          p2 += 1

          result << item1

          next
        end

        if min_key == key1
          p1 += 1

          result << item1
        else
          p2 += 1

          result << item2
        end
      end

      pp result

      result.reject { |(_key, value)| value.nil? || value.empty? }
    end
  end
end
