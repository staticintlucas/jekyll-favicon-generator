# frozen_string_literal: true

require "jekyll-favicon-generator/icon"
require "jekyll-favicon-generator/utilities"

module JekyllFaviconGenerator
  class Tag < Liquid::Tag
    # Use Jekyll's native relative_url filter
    include Jekyll::Filters::URLFilters
    include Utilities

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      # Jekyll::Filters::URLFilters requires `@context` to be set in the environment.
      @context = context
      @site = context.registers[:site]
      tags = []

      @site.static_files.each do |icon|
        next unless icon.is_a? Icon

        url = relative_url icon.url
        tag = icon.render_tag url
        tags << tag if tag
      end

      tags.join("\n")
    end
  end
end

Liquid::Template.register_tag("favicons", JekyllFaviconGenerator::Tag)
