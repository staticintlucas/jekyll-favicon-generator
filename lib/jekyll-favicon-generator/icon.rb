# frozen_string_literal: true

require "jekyll-favicon-generator/utilities"
require "jekyll-favicon-generator/icon_file"

require "fileutils"

module JekyllFaviconGenerator
  class Icon
    include Utilities

    def initialize(site, icon)
      @site = site
      @icon = icon
    end

    def generate(vips)
      debug "Generating #{filename}"
      @site.static_files << IconFile.new(@site, destination_file)

      FileUtils.mkdir_p @site.in_dest_dir(destination)
      src = @site.in_source_dir(source)
      dst = @site.in_dest_dir(destination_file)

      case type
      when :png
        vips.img_to_png src, dst, size
      when :ico
        vips.img_to_ico src, dst, size
      else
        warn "Unknown format for #{filename}, skipping"
      end
    end

    def filename
      @filename ||= @icon["file"]
    end

    private

    def destination_file
      # Only prepend the destination path if it is referenced, otherwise place it at the root
      @destination_file ||= File.join((ref ? destination : ""), filename)
    end

    def type
      @type ||= case File.extname(filename).downcase
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
      @size ||= size_array(@icon["size"]).tap { |s| break type == :ico && s || s[0] }
    end

    def ref
      @ref ||= @icon["ref"]
    end
  end
end
