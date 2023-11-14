# frozen_string_literal: true

require_relative "lib/jekyll-favicon-generator/version"

Gem::Specification.new do |spec|
  spec.name = "jekyll-favicon-generator"
  spec.version = JekyllFaviconGenerator::VERSION
  spec.authors = ["Lucas Jansen"]

  spec.summary = "Favicon generator for Jekyll."
  spec.description =
    "A simple and fast Jekyll plugin to generate favicons from a single source image."
  spec.homepage = "https://github.com/staticintlucas/jekyll-favicon-generator"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

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
  spec.add_dependency "bit-struct", "~> 0.17"
  spec.add_dependency "jekyll", ">= 3.7", "< 5.0"
  spec.add_dependency "nokogiri", "~> 1.12"
  spec.add_dependency "ruby-vips", "~> 2.1"
  spec.add_dependency "svg_optimizer", "~> 0.3"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
