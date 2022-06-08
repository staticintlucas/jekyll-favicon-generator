# frozen_string_literal: true

require "jekyll"

require "jekyll-svg-favicons/generator"

module JekyllSvgFavicons
  autoload :VERSION, "jekyll-svg-favicons/version"

  def debug(msg)
    Jekyll.logger.debug "SVG Favicons:", msg
  end

  def info(msg)
    Jekyll.logger.info "SVG Favicons:", msg
  end

  def warn(msg)
    Jekyll.logger.warn "SVG Favicons:", msg
  end

  def abort_with(msg)
    Jekyll.logger.abort_with "SVG Favicons:", msg
  end
end
