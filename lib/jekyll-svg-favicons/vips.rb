# frozen_string_literal: true

require "vips"

module JekyllSvgFavicons
  class LibVips
    def initialize(opts = {}) end

    def version
      "#{Vips.version(0)}.#{Vips.version(1)}.#{Vips.version(2)}"
    end

    def img_to_png(svg, png, size)
      img = Vips::Image.thumbnail svg, size, :height => size
      img.pngsave png
    end
  end
end
