# frozen_string_literal: true

require "jekyll-svg-favicons/inkscape"

require "fileutils"

module JekyllSvgFavicons
  class Generator < Jekyll::Generator
    include JekyllSvgFavicons

    def generate(site)
      @site = site
      @config = @site.config["svg-favicons"] || {}

      info "Generating favicons using favicon.svg"

      @source = @config["source"] || "favicon.svg"
      abort_with "File #{@source} not found!" unless file_exists? @source
      debug "Using #{@source}"

      Inkscape.new @config["inkscape"]
    end

    def file_exists?(file)
      File.exist? @site.in_source_dir(file)
    end
  end
end
