module Amnesia
  class Compactor
    def self.call(sstable_path1, sstable_path2)
      st1 = Amnesia::Storage.new(sstable_path1).all
      st2 = Amnesia::Storage.new(sstable_path2).all

      pp st1
      pp st2

      res = []

      p1 = p2 = 0

      loop do
        item1 = st1[p1]
        item2 = st2[p2]

        break if item1.nil? && item2.nil?

        key1 = item1[0] unless item1.nil?
        key2 = item2[0] unless item2.nil?

        puts "key1=#{key1} // key2=#{key2}"

        min_key = [key1, key2].min

        puts "Min key -> #{min_key}"

        puts "p1=#{p1} // p2=#{p2}"
        puts "\n\n"

        if key1 == key2
          p1 += 1
          p2 += 1

          res << item1

          next
        end

        if min_key == key1
          p1 += 1

          res << item1
        else
          p2 += 1

          res << item2
        end
      end

      filename = "./_data/#{Time.now.to_i}.c.segment"

      pp res

      Amnesia::Storage.new(filename, items: res)

      File.delete(sstable_path1, sstable_path2)

      #       item_st1 = st1.shift
      #       item_st2 = st2.shift

      #       loop do
      #         pair = [item_st1[0], item_st2[0]]
      #         result = nil

      #         if pair.uniq.size == 1
      #           result = item_st1
      #         else
      #           min_key = pair.min
      #           index = pair.index(min_key)
      #           result = index.zero? ? item_st1 : item_st2
      #         end

      #         pp result
      #         break

      #         break if st1.size == st2.size && st1.empty?
      #       end

      #       puts 'finished compaction'
    end
  end
end
