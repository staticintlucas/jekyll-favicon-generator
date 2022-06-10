# frozen_string_literal: true

require "jekyll-favicon-generator/icon"
require "jekyll-favicon-generator/utilities"
require "jekyll-favicon-generator/vips"

module JekyllFaviconGenerator
  class Generator < Jekyll::Generator
    include Utilities

    def initialize(site)
      @site = site
    end

    def generate(site)
      @site = site

      if file_exists? source
        config["source"] = source
      else
        error "File #{source} not found!"
        return
      end
      info "Generating favicons from #{source}"

      config["icons"].map do |icon|
        @site.static_files << Icon.new(site, icon)
      end
    end

    private

    def vips
      @vips ||= LibVips.new
    end
  end
end
