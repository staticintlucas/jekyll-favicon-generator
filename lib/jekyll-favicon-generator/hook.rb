# frozen_string_literal: true

require "jekyll-favicon-generator/utilities"

Jekyll::Hooks.register :site, :after_init do |site|
  # Adds the source image to the exclude list so it's not copied directly to the output
  site.exclude.push JekyllFaviconGenerator::UtilityClass.new(site).source
end
