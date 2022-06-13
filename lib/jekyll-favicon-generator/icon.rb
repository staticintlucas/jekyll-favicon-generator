# frozen_string_literal: true

require "jekyll-favicon-generator/ico"
require "jekyll-favicon-generator/utilities"
require "jekyll-favicon-generator/size"
require "jekyll-favicon-generator/svg"
require "jekyll-favicon-generator/vips"

require "fileutils"

module JekyllFaviconGenerator
  class Icon < Jekyll::StaticFile
    include Utilities

    def initialize(site, icon)
      @site = site
      @icon = icon

      super site, site.source, dest_dir, @icon["file"]
    end

    def write(dest)
      dest = destination dest
      src = @site.in_source_dir source

      FileUtils.mkdir_p(File.dirname(dest))
      debug "Writing #{File.basename dest}"

      case type
      when :png
        Vips.img_to_png src, dest, size.to_i
      when :ico
        Ico.img_to_ico src, dest, size.to_a
      when :svg
        Svg.optimize src, dest
      else
        warn "Unknown format for #{File.basename dest}, skipping"
        false
      end
    end

    def render_tag(url)
      return if ref.nil? || ref == :manifest

      attrs = attributes(url)
      unless tag_name && attrs
        warn "Unknown ref type for #{File.basename @icon["file"]}, skipping"
        return
      end

      attrs = attrs.map { |k, v| "#{k}=#{v.to_s.encode(:xml => :attr)}" }

      "<#{tag_name} #{attrs.join(" ")}>"
    end

    def type
      @type ||= TYPES[File.extname(name).downcase] || :unknown
    end

    def mime
      @mime ||= MIMES[type]
    end

    def size
      @size ||= Size.new @icon["size"]
    end

    def ref
      @ref ||= REFS[@icon["ref"]&.downcase]
    end

    private

    TYPES = {
      ".ico" => :ico,
      ".png" => :png,
      ".svg" => :svg,
    }.freeze

    MIMES = {
      :ico => "image/x-icon",
      :png => "image/png",
      :svg => "image/svg+xml",
    }.freeze

    REFS = {
      "link/icon"             => :link_icon,
      "link/apple-touch-icon" => :link_apple,
      "manifest"              => :manifest,
      "webmanifest"           => :manifest,
    }.freeze

    def tag_name
      @tag_name ||= case ref
                    when :link_icon, :link_apple
                      "link"
                    end
    end

    def attributes(url)
      case ref
      when :link_icon
        { :rel => "icon", :href => url, :sizes => (type == :svg ? "any" : size.to_s) }
      when :link_apple
        { :rel => "apple-touch-icon", :href => url, :sizes => size.to_s }
      end
    end

    def dest_dir
      ref ? super : ""
    end
  end
end
