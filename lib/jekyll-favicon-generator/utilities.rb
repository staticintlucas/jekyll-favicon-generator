# frozen_string_literal: true

require "jekyll-favicon-generator/configuration"

module JekyllFaviconGenerator
  module Utilities
    extend self

    # Logging functions

    LOGGER_PREFIX = "Favicon Generator:"

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

    # Parameters & defaults

    def config
      @config ||= Configuration.from @site.config["favicon-generator"] || {}
    end

    def source
      @source ||= config["source"] || find_source
    end

    def dest_dir
      @dest_dir ||= config["destination"] || ""
    end

    # File utilities

    def file_exists?(file)
      File.file? @site.in_source_dir(file)
    end

    def find_source
      [".svg", ".png"].map { |ext| "favicon#{ext}" }.find { |file| file_exists? file }
    end
  end

  # Class for accessing utility functions without instantiating anything bigger

  class UtilityClass
    include Utilities

    def initialize(site)
      @site = site
    end
  end
end
