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

    def img_to_png(img, png, size)
      img = Vips::Image.thumbnail img, size, :height => size
      img.pngsave png
    end
  end
end
