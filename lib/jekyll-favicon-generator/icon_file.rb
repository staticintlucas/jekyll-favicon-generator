# frozen_string_literal: true

module JekyllFaviconGenerator
  # Subclass of `Jekyll::StaticFile` with custom method definitions.
  class IconFile < Jekyll::StaticFile
    def initialize(site, file)
      super(site, site.source, File.dirname(file), File.basename(file))
    end

    def write(_dest)
      true
    end
  end
end
