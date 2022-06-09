# frozen_string_literal: true

require "jekyll-svg-favicons/configuration"

require "fileutils"

module JekyllSvgFavicons
  class Generator < Jekyll::Generator
    include JekyllSvgFavicons

    def generate(site)
      @site = site

      unless file_exists? source
        error "File #{source} not found!"
        return
      end
      info "Generating favicons from #{@source}"
    end

    private

    def inkscape
      @inkscape ||= Inkscape.new(@config["inkscape"])
    end

    def config
      @config ||= Configuration.from @site.config["svg-favicons"] || {}
    end

    def source
      @source ||= config["source"] || @site.in_source_dir("favicon.svg")
    end

    def file_exists?(file)
      File.exist? @site.in_source_dir(file)
    end
  end
end
