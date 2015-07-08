# coding: us-ascii

require 'stringio'

class Imagine
  class Jpeg < Base
    class FormatError < StandardError; end

    JPEG_PREFIX = [0xFF, 0xD8].pack("C2").freeze
    SOS = 0xDA
    FIELD_MARKER = 0xFF

    def initialize(io)
      @exifr = EXIFR::JPEG.new(io)
      io.rewind
      @io = StringIO.new(io.read)
    end

    def to_h
      @exifr.to_hash
    end

    def header
      @header ||= begin
        @io.rewind
        if @io.read(2) != JPEG_PREFIX
          fail FormatError, "not jpeg image"
        end
        read_to_sos
      end
    end

    def shot_time
      @exifr.date_time
    end

    private
      def read_to_sos
        loop do
          marker, frame = readframe
          case marker
          when SOS
            header_pos = @io.pos
            @io.rewind
            return @io.read(header_pos)
          else
            # ignore
          end
        end
      end

      def readframe
        field_marker = @io.read(2).unpack("C2")
        fail FormatError, 'invalid field format' unless field_marker[0] == FIELD_MARKER
        frame_size = @io.read(2).unpack("C2").inject(0){|r, v|
          r = r << 8
          r += v
        }
        [field_marker[1], @io.read(frame_size - 2)]
      end
  end
end
