# jekyll-favicon-generator

[![Gem Version](https://badge.fury.io/rb/jekyll-favicon-generator.svg)](https://badge.fury.io/rb/jekyll-favicon-generator)

A simple and fast Jekyll plugin to generate favicons from a single source image.

## Features

* Generates all favicons for your website using sensible modern defaults:
  * favicon.ico for legacy browsers
  * 16x16 and 32x32 PNG for IE11 and Safari which don't support SVG favicons
  * Optimized SVG (only supported when the source image is also SVG)
  * 180x180 apple-touch-icon
  * 192x192 and 512x512 Android icons linked from site.webmanifest
* Fully configurable through your _config.yml
* Adds negligible time to your build process by using ruby-vips for image processing
* No additional non-ruby dependencies besides libvips

## Installation

Ensure libvips is installed on your system.

* On Debian/Ubuntu:

      $ apt install libvips

* On MacOS with Homebrew:

      $ brew install vips

* On Windows see the instructions on the libvips website [here](https://www.libvips.org/install.html).

Install the gem and add to the application's Gemfile by executing:

    $ bundle add jekyll-favicon-generator

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install jekyll-favicon-generator

## Usage

### Default configuration

```yaml
favicon-generator:
  source: nil # by default automatically find favicon.* image in source root
  destination: assets/icons # where generated favicons are stored
  color: '#000000' # Foreground color; used in site.webmanifest
  background: '#ffffff' # Background color; used in site.webmanifest
  icons:
  - file: favicon.ico # File name for the icon
    size: '16,24,32,48' # Sizes to generate; only .ico files can have multiple sizes
    ref: nil # Always placed in the site root regardless of the destination option
  - file: favicon-16.png
    size: 16
    ref: link/icon # Referenced from a <link rel="icon"> tag
  - file: favicon-32.png
    size: 32 # Icons are always square, so only one dimension is necessary
    ref: link/icon
  - file: favicon.svg
    size: nil # Size is ignored for SVG favicons
    ref: link/icon
  - file: apple-touch-icon.png
    size: 180
    ref: link/apple-touch-icon # Referenced from a <link rel="apple-touch-icon"> tag
  - file: android-chrome-192.png
    size: 192
    ref: manifest # Referenced from a generated site.webmanifest file
                  # The webmanifest is automatically linked using a <link rel="manifest"> tag
  - file: android-chrome-512.png
    size: 512
    ref: manifest
```

### Generated tags

To render tags for all the generated icons, use the following Liquid tag:

```liquid
{% favicons %}
```

With the default configuration this renders as:

```html
<link rel="icon" href="/assets/icons/favicon-16.png" sizes="16x16">
<link rel="icon" href="/assets/icons/favicon-32.png" sizes="32x32">
<link rel="icon" href="/assets/icons/favicon.svg" sizes="any">
<link rel="apple-touch-icon" href="/assets/icons/apple-touch-icon.png" sizes="180x180">
<link rel="manifest" href="/site.webmanifest">
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/staticintlucas/jekyll-favicon-generator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/staticintlucas/jekyll-favicon-generator/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the `jekyll-favicon-generator` project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/staticintlucas/jekyll-favicon-generator/blob/master/CODE_OF_CONDUCT.md).
