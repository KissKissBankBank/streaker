require 'spec_helper'

RSpec.describe Streaker::Configuration do
  describe 'Streaker.configure' do
    # Cleanup after our examples in order not to change the test configuration
    around do |example|
      configuration = Streaker.configuration.dup
      example.run
      Streaker.configuration = configuration
    end

    it 'changes the Streaker configuration' do
      Streaker.configure do |config|
        config.api_key = 'some_test_api_key'
        config.pipeline_keys = { some: 'pipeline_key' }
        config.stage_keys = { some: 'stage_key' }
        config.field_keys = { some: 'field_key' }
      end

      expect(Streaker.configuration.api_key).to eq('some_test_api_key')
      expect(Streaker.configuration.pipeline_keys).to eq(some: 'pipeline_key')
      expect(Streaker.configuration.stage_keys).to eq(some: 'stage_key')
      expect(Streaker.configuration.field_keys).to eq(some: 'field_key')
    end

    it 'changes the Streak configuration' do
      Streaker.configure do |config|
        config.api_key = 'some_test_api_key'
      end

      expect(Streak.api_key).to eq('some_test_api_key')
    end
  end
end
