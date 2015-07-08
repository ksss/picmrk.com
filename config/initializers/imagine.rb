module Imagine2
  module ActiveRecord
    module Attachment
      def imagine(name, format:, &block)
        @versions = Imagine::Versions.new
        @versions.instance_eval do
          version :original do
          end
        end
        @versions.instance_exec(&block)

        define_method("#{name}=") do |uploader|
          IO.copy_stream(uploader, __send__("#{name}_path"))
        end

        define_method("#{name}_path") do
          filename = File.join("tmp", "upload", "cache", "#{id}_#{version_name}#{".#{format}" if format}")
        end

        before_save do
          versions.each do |version_name, pr|
            filename = "#{id}_#{version_name}#{".#{format}" if format}"
            Processor.new(version_name, pr).process
          end
        end

        after_destory do
          versions.each do |version_name, pr|
            filename = "#{id}_#{version_name}#{".#{format}" if format}"
            Processor.new(filename, pr).remove
          end
        end
      end
    end
  end

  class Versions
    attr_accessor :versions
    def initialize
      @versions = {}
    end
    def version(name, &block)
      versions[name] = block
    end
  end

  class Processor
    attr_accessor :img
    def initialize(filename, block)
      @filename = filename
      @block = block
      @image = ::MiniMagick::Image.new(filename)
      @img = nil
    end
    def process
      @image.combine_options do |img|
        @img = img
        instance_exec &@block
      end
      @img = nil
    end
    def remove
      raise NotImplementedError
    end
    def strip
      img.strip
    end
    def fit(width, height)
      img.resize "#{width}x#{height}"
    end
    def fill(width, height, gravity = "Center")
      width = width.to_i
      height = height.to_i
      cols, rows = img[:dimensions]
      if width != cols || height != rows
        scale_x = width / cols.to_f
        scale_y = height / rows.to_f
        if scale_x >= scale_y
          cols = (scale_x * (cols + 0.5)).round
          rows = (scale_x * (rows + 0.5)).round
          img.resize "#{cols}"
        else
          cols = (scale_y * (cols + 0.5)).round
          rows = (scale_y * (rows + 0.5)).round
          img.resize "x#{rows}"
        end
      end
      img.gravity gravity
      img.background "rgba(255,255,255,0.0)"
      img.extent "#{width}x#{height}" if cols != width || rows != height
    end
  end
end

#::ActiveRecord::Base.extend(Imagine::ActiveRecord::Attachment)
