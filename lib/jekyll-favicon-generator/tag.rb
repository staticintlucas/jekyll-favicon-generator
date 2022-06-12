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

      tags = @site.static_files
        .select { |s| s.is_a?(Icon) }
      tags.map!(&:render_tag)
      tags.select! { |tag, attrs| tag && attrs }
      tags.map! do |tag, attrs|
        attrs = attrs.map { |k, v| "#{k}=#{v.to_s.encode(:xml => :attr)}" }
        "<#{tag} #{attrs.join(" ")}>"
      end

      tags.uniq.join("\n")
    end
  end
end

Liquid::Template.register_tag("favicons", JekyllFaviconGenerator::Tag)