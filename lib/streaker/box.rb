module Streaker
  # Represents a Streak Box through the API.
  class Box
    class Error < RuntimeError
    end

    attr_reader :key

    def initialize(key)
      @key = key
    end

    # Update data for a box:
    #     box = Box.new('someboxkey')
    #     box.update(
    #       name: 'Some box name',
    #       stage: :some_stage,
    #       some_field_key: 'Some field value',
    #       …
    #     )
    #
    # You can also give a `stage: :stage` or
    def update(attributes)
      verify_if_box_exists
      api_result = api.update_box(key, attributes)

      raise Streaker::Box::Error, api_result['error'] if api_result['error']

      true
    end

    # Create a Streak box:
    #     box = Box.create(
    #       pipeline: :some_pipeline_name,
    #       name: 'Some box name',
    #       stage: :some_stage,
    #       some_field_key: 'Some field value',
    #       …
    #     )
    def self.create(name:, pipeline: :default, assigned_to: [], **attributes)
      api = Streaker::API.new
      api_result = api.create_box(
        pipeline_key(pipeline),
        name: name,
        assigned_to: assigned_to
      )

      raise Streaker::Box::Error, api_result['error'] if api_result['error']

      api.update_box(api_result['key'], name: name, **attributes)

      new(api_result['key'])
    end

    def self.pipeline_key(pipeline)
      Streaker.configuration.pipeline_keys.fetch(pipeline)
    rescue KeyError
      raise Error,
            "No such pipeline #{pipeline.inspect} in the configuration"
    end

    private_class_method :pipeline_key

    private

    def verify_if_box_exists
      result = api.find_box(key)

      return unless result['error']

      if /Entity not found with key/ =~ result['error']
        raise Streaker::BoxNotFoundError, result['error']
      end

      raise Streaker::Box::Error, result['error']
    end

    def stage_key(stage)
      Streaker.configuration.stage_keys.fetch(stage)
    rescue KeyError
      raise Error,
            "No such stage #{stage.inspect} in the configuration"
    end

    def field_key(field)
      Streaker.configuration.field_keys.fetch(field)
    rescue KeyError
      raise Error,
            "No such field #{field.inspect} in the configuration"
    end

    def api
      Streaker::API.new
    end
  end
end
