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
      attributes.each do |attr, value|
        update_attribute(attr, value)
      end

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
    def self.create(name:, pipeline: :default, **attributes)
      api_result = Streak::Box.create(pipeline_key(pipeline), name: name)
      box = new(api_result.key)
      box.update(attributes)
      box
    end

    def self.pipeline_key(pipeline)
      Streaker.configuration.pipeline_keys.fetch(pipeline)
    rescue KeyError
      raise Error,
            "No such pipeline #{pipeline.inspect} in the configuration"
    end

    private_class_method :pipeline_key

    private

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

    def update_attribute(attr, value)
      case attr
      when :stage
        Streak::Box.update(key, stageKey: stage_key(value))
      when :name
        Streak::Box.update(key, name: value)
      else
        Streak::FieldValue.update(key, field_key(attr), value: value)
      end
    end
  end
end
