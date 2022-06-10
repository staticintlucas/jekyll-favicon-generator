# frozen_string_literal: true

require "jekyll-favicon-generator/icon_file"

require "fileutils"

module JekyllFaviconGenerator
  class Icon
    include JekyllFaviconGenerator

    def initialize(site, config, icon)
      @site = site
      @config = config
      @icon = icon

      return unless dest_filename
    end

    def generate(vips)
      debug "Generating #{destination}"
      @site.static_files << IconFile.new(@site, destination)

      FileUtils.mkdir_p @site.in_dest_dir(dest_dir)

      case type
      when :png
        vips.img_to_png source, destination, size
      when :ico
        vips.img_to_ico source, destination, size
      else
        warn "Unknown format for #{dest_filename}, skipping"
      end
    end

    def source
      @source ||= @site.in_source_dir @config["source"]
    end

    def destination
      @destination ||= @site.in_dest_dir(File.join(dest_dir, dest_filename))
    end

    private

    def dest_filename
      @dest_filename ||= @icon["file"]
    end

    def dest_dir
      @dest_dir ||= (@config["destination"] if ref) || ""
    end

    def type
      @type ||= case File.extname(dest_filename).downcase
                when ".ico"
                  :ico
                when ".png"
                  :png
                when ".svg"
                  :svg
                else
                  :unknown
                end
    end

    def size
      return @size if @size

      sizes = split_sizes @icon["size"]
      sizes = [16] if sizes.empty?

      @size ||= (type == :ico ? sizes : sizes[0])
    end

    def ref
      @ref ||= @icon["ref"]
    end

    def split_sizes(size)
      size&.split(",")&.map(&:to_i)&.reject(&:zero?)
    end
  end
end
