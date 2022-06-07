# frozen_string_literal: true

require_relative "lib/jekyll-svg-favicons/version"

Gem::Specification.new do |spec|
  spec.name = "jekyll-svg-favicons"
  spec.version = JekyllSvgFavicons::VERSION
  spec.authors = ["Lucas Jansen"]

  spec.summary = "Favicon generator for Jekyll."
  spec.description = "Generates all necessary favicons for your site from a single source SVG."
  spec.homepage = "https://github.com/staticintlucas/jekyll-svg-favicons"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir["lib/**/*"]
  # spec.bindir = "exe"
  # spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "jekyll", ">= 3.7", "< 5.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
