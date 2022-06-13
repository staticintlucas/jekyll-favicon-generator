# frozen_string_literal: true

require "jekyll-favicon-generator/utilities"

require "nokogiri"
require "svg_optimizer"

module JekyllFaviconGenerator
  module Svg
    include Utilities
    extend self

    def optimize(src, dest)
      unless File.extname(src).casecmp(".svg").zero?
        warn "Unsupported #{File.extname(src).downcase} -> .svg for #{dest}"
        return false
      end

      xml = Nokogiri::XML File.read(src) { |config| config.recover.noent }

      SvgOptimizer::DEFAULT_PLUGINS.each { |plugin| plugin.new(xml).process }

      File.open(dest, "w") do |file|
        file << xml.root.to_xml(:indent => 0).delete("\n")
      end
      true
    end
  end
end
