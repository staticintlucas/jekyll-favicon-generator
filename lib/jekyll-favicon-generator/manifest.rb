# frozen_string_literal: true

require "jekyll-favicon-generator/utilities"

module JekyllFaviconGenerator
  class Manifest < Jekyll::Page
    include Utilities

    def initialize(site, icons)
      @site = site
      @base = site.source
      @dir  = ""
      @name = MANIFEST_NAME
      @path = manifest_template

      process(name)
      read_yaml(site.source, name)

      data.default_proc = proc do |_, key|
        site.frontmatter_defaults.find(relative_path, type, key)
      end
      data.merge! icon_data icons

      Jekyll::Hooks.trigger :pages, :post_init, self
    end

    private

    MANIFEST_NAME = "site.webmanifest"

    def manifest_template
      @manifest_template ||= if file_exists? MANIFEST_NAME
                               site.in_source_dir MANIFEST_NAME
                             else
                               File.expand_path MANIFEST_NAME, __dir__
                             end
    end

    def icon_data(icons)
      data = {}
      data["icons"] = icons.map do |icon|
        { "url" => icon.url, "size" => icon.size.to_s, "mime" => icon.mime }
      end
      data["color"] = config["color"]
      data["background"] = config["background"]
      data
    end
  end
end
