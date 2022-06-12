# frozen_string_literal: true

require "jekyll-favicon-generator/icon"
require "jekyll-favicon-generator/utilities"
require "jekyll-favicon-generator/vips"
require "jekyll-favicon-generator/manifest"

module JekyllFaviconGenerator
  class Generator < Jekyll::Generator
    include Utilities

    def initialize(site)
      @site = site
    end

    def generate(site)
      @site = site

      debug "Using libvips #{Vips.version}"

      unless file_exists? source
        error "File #{source} not found!"
        return
      end
      info "Generating favicons from #{source}"

      @site.static_files.push(*icons)
      @site.pages.push(*manifests)
    end

    private

    def icons
      @icons ||= config["icons"].filter_map { |icon| Icon.new(@site, icon) if icon["file"] }
    end

    def manifests
      return @manifests if @manifests

      @manifests = []
      manifest_icons = icons.select { |icon| icon.ref == :manifest }
      @manifests << Manifest.new(@site, manifest_icons) unless manifest_icons.empty?
      @manifests
    end
  end
end
