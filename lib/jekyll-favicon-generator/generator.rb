# frozen_string_literal: true

require "jekyll-favicon-generator/configuration"
require "jekyll-favicon-generator/icon"
require "jekyll-favicon-generator/icon_file"
require "jekyll-favicon-generator/vips"

module JekyllFaviconGenerator
  class Generator < Jekyll::Generator
    include JekyllFaviconGenerator

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

      config["icons"].map { |icon| Icon.new(site, config, icon).generate(vips) }
    end

    def config
      @config ||= Configuration.from @site.config["favicon-generator"] || {}
    end

    def source
      @source ||= config["source"] || find_source
    end

    private

    def vips
      @vips ||= LibVips.new
    end

    def find_source
      [".svg", ".png"].map { |ext| "favicon#{ext}" }.find { |f| file_exists? f }
    end

    def get_size(size)
      size&.to_i || 16
    end

    def get_size_array(size)
      size&.split(",")&.map(&:to_i)&.reject(&:zero?) || [16]
    end

    def file_exists?(file)
      File.file? @site.in_source_dir(file)
    end
  end
end
