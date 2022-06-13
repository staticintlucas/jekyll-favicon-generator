# frozen_string_literal: true

require "jekyll-favicon-generator/icon"
require "jekyll-favicon-generator/manifest"
require "jekyll-favicon-generator/utilities"

module JekyllFaviconGenerator
  class Tag < Liquid::Tag
    # Use Jekyll's native relative_url filter
    include Jekyll::Filters::URLFilters
    include Utilities

    def render(context)
      # Jekyll::Filters::URLFilters requires `@context` to be set in the environment.
      @context = context
      @site = context.registers[:site]

      tags = @site.static_files.filter_map do |icon|
        icon.render_tag relative_url icon.url if icon.is_a? Icon
      end
      tags += @site.pages.filter_map do |manifest|
        "<link rel=\"manifest\" href=\"#{relative_url manifest.url}\">" if manifest.is_a? Manifest
      end

      tags.join("\n")
    end
  end
end

Liquid::Template.register_tag("favicons", JekyllFaviconGenerator::Tag)
