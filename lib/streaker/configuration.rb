# Configuration variables and defaults.
module Streaker
  # The configuration singleton.
  class Configuration
    attr_reader :api_key
    attr_accessor :pipeline_keys,
                  :stage_keys,
                  :field_keys

    def initialize
      @api_key = ''
      @pipeline_keys = {}
      @stage_keys = {}
      @field_keys = {}
    end

    def api_key=(value)
      @api_key = value

      Streak.api_key = value
    end
  end

  # Configuration setup
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)

      if !configuration.api_key || configuration.api_key == ''
        raise(ArgumentError, '`api_key` must be set in the configuration')
      end

      configuration
    end
  end
end
