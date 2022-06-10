# frozen_string_literal: true

require "vips"

require "jekyll-favicon-generator/utilities"

module JekyllFaviconGenerator
  module Vips
    include Utilities

    def self.version
      "#{::Vips.version(0)}.#{::Vips.version(1)}.#{::Vips.version(2)}"
    end

    def self.img_to_png(src, png, size)
      img = ::Vips::Image.thumbnail src, size, :height => size
      img.pngsave png
    end
  end
end
