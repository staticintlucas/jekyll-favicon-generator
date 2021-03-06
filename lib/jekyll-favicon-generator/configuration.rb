# frozen_string_literal: true

module JekyllFaviconGenerator
  class Configuration < Jekyll::Configuration
    # Default options. Overridden by values in _config.yml.
    # Strings rather than symbols are used for compatibility with YAML.
    DEFAULTS = {
      "source"      => nil,
      "destination" => "assets/icons",
      "color"       => "#000000",
      "background"  => "#ffffff",
      "icons"       => [
        {
          "file" => "favicon.ico",
          "size" => "16,24,32,48",
          "ref"  => nil,
        },
        {
          "file" => "favicon-16.png",
          "size" => 16,
          "ref"  => "link/icon",
        },
        {
          "file" => "favicon-32.png",
          "size" => 32,
          "ref"  => "link/icon",
        },
        {
          "file" => "favicon.svg",
          "ref"  => "link/icon",
        },
        {
          "file" => "apple-touch-icon.png",
          "size" => 180,
          "ref"  => "link/apple-touch-icon",
        },
        {
          "file" => "android-chrome-192.png",
          "size" => 192,
          "ref"  => "manifest",
        },
        {
          "file" => "android-chrome-512.png",
          "size" => 512,
          "ref"  => "manifest",
        },
      ],
    }.freeze

    class << self
      # Static: Produce a Configuration ready for use in a Site.
      # It takes the input, fills in the defaults where values do not exist.
      #
      # user_config - a Hash or Configuration of overrides.
      #
      # Returns a Configuration filled with defaults.
      def from(user_config)
        Jekyll::Utils.deep_merge_hashes(DEFAULTS, Configuration[user_config].stringify_keys)
      end
    end
  end
end
