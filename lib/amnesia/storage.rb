module Amnesia
  class Storage
    def initialize(filename)
      @filename = filename
    end

    def set(key, value)
      File.write(@filename, "#{key},#{value}\n", mode: 'a+')
    end

    def get(key)
      lines = File.readlines(@filename)

      result = lines.filter do |line|
        record_key, = line.split(',', 2)
        record_key == key
      end

      result.last.split(',', 2)[1]
    end

    def create_db_file
      File.write(@filename, '') unless file_exists?
    end

    def file_exists?
      File.exist?(@filename)
    end
  end
end
