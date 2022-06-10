# frozen_string_literal: true

Jekyll::Hooks.register :site, :after_init do |site|
  # Adds the source SVG to the exclude list so it's not copied directly to the output
  config = site.config["svg-favicons"] || {}
  source = config["source"] || "favicon.svg"
  site.exclude.push source
end
