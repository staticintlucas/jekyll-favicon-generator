# frozen_string_literal: true

require "jekyll-favicon-generator/ico"
require "jekyll-favicon-generator/utilities"
require "jekyll-favicon-generator/vips"

module JekyllFaviconGenerator
  class Icon < Jekyll::StaticFile
    include Utilities

    def initialize(site, icon)
      @site = site
      @icon = icon

      super site, site.source, dest_dir, @icon["file"]
    end

    def write(dest)
      dest = destination dest
      src = @site.in_source_dir source

      debug "Writing #{File.basename dest}"

      case type
      when :png
        Vips.img_to_png src, dest, size
      when :ico
        Ico.img_to_ico src, dest, size
      else
        warn "Unknown format for #{File.basename dest}, skipping"
        return false
      end

      true
    end

    private

    def type
      @type ||= case File.extname(name).downcase
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

    def dest_dir
      ref ? super : ""
    end
  end
end
