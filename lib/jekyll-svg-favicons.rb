# frozen_string_literal: true

require "jekyll"

require "jekyll-svg-favicons/generator"

module JekyllSvgFavicons
  autoload :VERSION, "jekyll-svg-favicons/version"

  def debug(topic = "SVG Favicons:", msg) # rubocop:disable Style/OptionalArguments
    Jekyll.logger.debug topic, msg
  end

  def info(topic = "SVG Favicons:", msg) # rubocop:disable Style/OptionalArguments
    Jekyll.logger.info topic, msg
  end

  def warn(topic = "SVG Favicons:", msg) # rubocop:disable Style/OptionalArguments
    Jekyll.logger.warn topic, msg
  end

  def abort_with(topic = "SVG Favicons:", msg) # rubocop:disable Style/OptionalArguments
    Jekyll.logger.abort_with topic, msg
  end
end
