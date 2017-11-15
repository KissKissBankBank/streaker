require 'bundler/setup'
require 'streaker'

# Help debugging

require 'pry'

# Load local credentials

credentials_file = "#{__dir__}/../credentials.rb"
load credentials_file if File.exist?(credentials_file)

# Default Streaker configuration

Streaker.configure do |config|
  config.pipeline_keys[:default] ||= 'fakepipelinekey'
  config.stage_keys[:fake_stage] ||= 5004
  config.field_keys[:fake_field] ||= 1001
end

# Mock HTTP Interactions

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
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
