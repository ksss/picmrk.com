# coding: us-ascii

require 'imagine/jpeg'

class Imagine
  class NotSupportError < StandardError; end
  SUPPORTED_EXTNAMES = %w(.jpg .jpeg)

  class << self
    def new(file)
      if file.kind_of?(String)
        File.open(file, 'rb') { |io| examine(io) }
      else
        examine(file)
      end
    end

    def examine(io)
      io.binmode
      chunk = io.read(2)
      io.rewind
      case chunk
      when "\xFF\xD8"
        Jpeg.new(io)
      else
        fail NotSupportError, "file type not supprted (supprt by #{SUPPORTED_EXTNAMES})"
      end
    end
  end
end
