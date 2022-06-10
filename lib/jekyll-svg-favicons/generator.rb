# frozen_string_literal: true

require "jekyll-svg-favicons/configuration"
require "jekyll-svg-favicons/vips"
require "jekyll-svg-favicons/icon_file"

module JekyllSvgFavicons
  class Generator < Jekyll::Generator
    include JekyllSvgFavicons

    def generate(site)
      @site = site

      unless file_exists? source
        error "File #{source} not found!"
        return
      end
      info "Generating favicons from #{@source}"

      debug "Using libvips #{vips.version}"

      config["icons"].map { |icon| generate_icon icon }
    end

    def generate_icon(icon)
      file = icon["file"]
      return unless file

      debug "Generating #{file}"
      @site.static_files << IconFile.new(@site, file)

      size = icon["size"]

      case File.extname(file).downcase
      when ".png"
        vips.img_to_png @site.in_source_dir(source), @site.in_dest_dir(file), get_size(size)
      when ".ico"
        vips.img_to_ico @site.in_source_dir(source), @site.in_dest_dir(file), get_size_array(size)
      else
        warn "Unknown format for #{file}, skipping"
      end
    end

    private

    def vips
      @vips ||= LibVips.new
    end

    def config
      @config ||= Configuration.from @site.config["svg-favicons"] || {}
    end

    def source
      @source ||= config["source"] || find_source
    end

    def find_source
      [".svg", ".png"].map { |ext| "favicon#{ext}" }.find { |f| file_exists? f }
    end

    def get_size(size)
      size&.to_i || 16
    end

    def get_size_array(size)
      size&.split(",")&.map(&:to_i)&.reject(&:zero?) || [16]
    end

    def file_exists?(file)
      File.file? @site.in_source_dir(file)
    end
  end
end
