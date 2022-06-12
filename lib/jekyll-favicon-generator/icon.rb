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
      return unless ref

      attrs = attributes(url)
      unless tag_name && attrs
        warn "Unknown ref type for #{File.basename @icon["file"]}, skipping"
        return
      end

      attrs = attrs.map { |k, v| "#{k}=#{v.to_s.encode(:xml => :attr)}" }

      "<#{tag_name} #{attrs.join(" ")}>"
    end

    private

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

    def size
      @size ||= size_array(@icon["size"]).tap { |s| break type == :ico && s || s[0] }
    end

    def ref
      @ref ||= @icon["ref"]&.downcase
    end

    def tag_name
      @tag_name ||= case ref
                    when "link/icon", "link/apple-touch-icon"
                      "link"
                    end
    end

    def attributes(url)
      case ref
      when "link/icon"
        { :rel => "icon", :href => url, :sizes => sizes_attr }
      when "link/apple-touch-icon"
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
