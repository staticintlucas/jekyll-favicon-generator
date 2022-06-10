# frozen_string_literal: true

require "jekyll"

require "jekyll-svg-favicons/generator"
require "jekyll-svg-favicons/hook"

module JekyllSvgFavicons
  autoload :VERSION, "jekyll-svg-favicons/version"

  LOGGER_PREFIX = "SVG Favicons:"

  def debug(topic = LOGGER_PREFIX, msg) # rubocop:disable Style/OptionalArguments
    Jekyll.logger.debug topic, msg
  end

  def info(topic = LOGGER_PREFIX, msg) # rubocop:disable Style/OptionalArguments
    Jekyll.logger.info topic, msg
  end

  def warn(topic = LOGGER_PREFIX, msg) # rubocop:disable Style/OptionalArguments
    Jekyll.logger.warn topic, msg
  end

  def error(topic = LOGGER_PREFIX, msg) # rubocop:disable Style/OptionalArguments
    Jekyll.logger.error topic, msg
  end

  def abort_with(topic = LOGGER_PREFIX, msg) # rubocop:disable Style/OptionalArguments
    Jekyll.logger.abort_with topic, msg
  end
end
