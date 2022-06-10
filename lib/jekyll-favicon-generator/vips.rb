# frozen_string_literal: true

require "vips"

require "jekyll-favicon-generator/ico"

module JekyllFaviconGenerator
  class LibVips
    include JekyllFaviconGenerator::Ico

    def initialize(opts = {}) end

    def version
      "#{Vips.version(0)}.#{Vips.version(1)}.#{Vips.version(2)}"
    end

    def img_to_png(src, png, size)
      img = Vips::Image.thumbnail src, size, :height => size
      img.pngsave png
    end
  end
end
