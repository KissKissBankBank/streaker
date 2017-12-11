lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'streaker/version'

# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |spec|
  spec.name = 'streaker'
  spec.version = Streaker::VERSION
  spec.authors = ['Sunny Ripert', 'William Pollet']
  spec.email = %w[
    sunny.ripert@kisskissbankbank.com
    william.pollet@KissKissBankBank.com
  ]

  spec.summary = 'Access the Streak API'
  spec.description = 'Access the Streak API thanks to the streak-ruby gem'
  spec.homepage = 'https://github.com/KissKissBankBank/streaker'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(spec|fixtures)/})
  end
  spec.require_paths = ['lib']

  # API Bindings to Streak
  spec.add_dependency 'streak-ruby', '>= 0.0.2', '< 1'

  # Record HTTP Interactions
  spec.add_development_dependency 'vcr', '~> 3.0'

  # Mock HTTP requests
  spec.add_development_dependency 'webmock', '~> 3.1'

  # A different console for debugging
  spec.add_development_dependency 'pry', '~> 0.11'

  spec.add_development_dependency 'bundler', '>= 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  # Ruby linter
  spec.add_development_dependency 'rubocop', '~> 0.51.0'
end
# rubocop:enable Metrics/BlockLength
