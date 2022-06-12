# frozen_string_literal: true

require "jekyll-favicon-generator/ico"
require "jekyll-favicon-generator/utilities"
require "jekyll-favicon-generator/vips"

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

      debug "Writing #{File.basename dest}"

      case type
      when :png
        Vips.img_to_png src, dest, size
      when :ico
        Ico.img_to_ico src, dest, size
      else
        warn "Unknown format for #{File.basename dest}, skipping"
        return false
      end

      true
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
      @type ||= case File.extname(name).downcase
                when ".ico"
                  :ico
                when ".png"
                  :png
                when ".svg"
                  :svg
                else
                  :unknown
                end
    end

    def mime
      @mime ||= case type
                when :ico
                  "image/x-icon"
                when :png
                  "image/png"
                when :svg
                  "image/svg+xml"
                end
    end

    def size
      @size ||= size_array(@icon["size"]).tap { |s| break type == :ico && s || s[0] }
    end

    def ref
      @ref ||= case @icon["ref"]&.downcase
               when "link/icon"
                 :link_icon
               when "link/apple-touch-icon"
                 :link_apple
               when "manifest", "webmanifest"
                 :manifest
               else
                 nil
               end
    end

    private

    def tag_name
      @tag_name ||= case ref
                    when :link_icon, :link_apple
                      "link"
                    end
    end

    def attributes(url)
      case ref
      when :link_icon
        { :rel => "icon", :href => url, :sizes => sizes_attr }
      when :link_apple
        { :rel => "apple-touch-icon", :href => url, :sizes => sizes_attr }
      end
    end

    def sizes_attr
      @sizes_attr ||= if type == :svg
                        "any"
                      else
                        size_array(@icon["size"]).map { |s| "#{s}x#{s}" }.join(" ")
                      end
    end

    def dest_dir
      ref ? super : ""
    end
  end
end
