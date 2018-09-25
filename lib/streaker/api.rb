module Streaker
  # Allow the streaker gem to execute http calls to the streak api
  class API
    STREAK_URL = 'https://www.streak.com'.freeze

    def initialize(api_key: nil)
      @api_key = api_key || Streaker.configuration.api_key
    end

    def update_box(key, attributes)
      response = client.post(
        "#{STREAK_URL}/api/v1/boxes/#{key}",
        json: update_box_params(attributes)
      )

      JSON.parse(response.body.to_s)
    end

    def create_box(pipeline_key, name:, assigned_to: [])
      response = client.put(
        "#{STREAK_URL}/api/v1/pipelines/#{pipeline_key}/boxes",
        form: create_box_params(name: name, assigned_to: assigned_to)
      )

      JSON.parse(response.body.to_s)
    end

    def find_box(box_key)
      response = client.get(
        "#{STREAK_URL}/api/v1/boxes/#{box_key}"
      )

      JSON.parse(response.body.to_s)
    end

    private_constant :STREAK_URL

    private

    attr_reader :api_key

    def update_box_params(attributes)
      {
        name: attributes.delete(:name),
        stageKey: find_streak_stage_key_key(attributes.delete(:stage)),
        assignedToSharingEntries: format_emails(
          attributes.delete(:assigned_to),
        ),
        fields: format_fields_for_streak(attributes)
      }.delete_if { |_k, v| v.nil? }
    end

    def create_box_params(name:, assigned_to: [])
      return { name: name } unless assigned_to.any?

      {
        name: name,
        assignedToSharingEntries: format_emails(assigned_to).to_json
      }
    end

    def format_emails(array)
      return unless array

      array.map do |email|
        {
          email: email
        }
      end
    end

    def format_fields_for_streak(attributes)
      attributes.map { |k, v| [Streaker.configuration.field_keys[k], v] }.to_h
    end

    def find_streak_stage_key_key(key)
      Streaker.configuration.stage_keys[key]
    end

    def client
      @client ||= HTTP.headers(accept: 'application/json').basic_auth(
        user: api_key,
        pass: ''
      )
    end
  end
end
