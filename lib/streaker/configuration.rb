module Streaker
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end

  # Configuration variables and defaults.
  class Configuration
    attr_accessor :api_key,
                  :pipeline_keys,
                  :stage_keys,
                  :field_keys


    def initialize
      @api_key = ''
      @pipeline_keys = {}
      @stage_keys = {}
      @field_keys = {}
    end
  end
end
