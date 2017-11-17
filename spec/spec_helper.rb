require 'bundler/setup'
require 'streaker'

# Help debugging

require 'pry'

# Default Streaker configuration

Streaker.configure do |config|
  # Fake api key that can be overridden in a `credentials.rb` file
  config.api_key = 'blahblahblahblahblahblahblahblah'

  # Real pipeline key to help with VCR's real requests
  config.pipeline_keys[:default] =
    'agxzfm1haWxmb29nYWVyOwsSDE9yZ2FuaXphdGlvbiIUa2lzc2tpc3NiYW5rYmFuay5jb20M' \
    'CxIIV29ya2Zsb3cYgICAgMHXgQoM'

  config.stage_keys = { fake_stage: 5004 }
  config.field_keys = { fake_field: 1001 }
end

# Load local credentials

credentials_file = "#{__dir__}/../credentials.rb"
load credentials_file if File.exist?(credentials_file)

# Mock HTTP Interactions

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/vcr_cassettes'

  config.default_cassette_options = {
    allow_unused_http_interactions: false,
    match_requests_on: %i[method uri body],
  }

  config.hook_into :webmock
end

# Configure RSpec

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
