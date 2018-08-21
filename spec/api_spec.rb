require 'spec_helper'

RSpec.describe Streaker::API do
  describe '#update_box' do
    let(:api) { Streaker::API.new }

    context 'the key is valid' do
      let(:key) do
        'agxzfm1haWxmb29nYWVyNAsSDE9yZ2FuaXphdGlvbiIUa2lzc2tpc3NiYW5rYmFuay' \
        '5jb20MCxIEQ2FzZRjRkeSNAww'
      end

      it 'updates fields' do
        VCR.use_cassette('api_one_field_update') do
          expect(
            api.update_box(key, fake_field: 'New test field value')
          ).to be_truthy
        end
      end

      it 'changes stage' do
        VCR.use_cassette('api_stage_update') do
          expect(api.update_box(key, stage: 5003)).to be_truthy
        end
      end

      it 'changes name' do
        VCR.use_cassette('api_name_update') do
          expect(
            api.update_box(key, name: 'Some Streak test name')
          ).to be_truthy
        end
      end
    end

    context 'the key is invalid' do
      let(:key) do
        'agxzfm1haWxmb29nYWVyNAsSDE9yZ2FuaXphdGlvbiIUa2lzc2tpc3NiYW5rYmFuay5' \
        'jb20MCxIEQ2FzZRihsMPGAQw'
      end
      let(:error_message) do
        { 'success' => false, 'error' => 'existing entity does not exist' }
      end

      it 'raises returns an error' do
        VCR.use_cassette('api_not_found_error') do
          expect(
            api.update_box(key, name: 'new_test_value')
          ).to eq(error_message)
        end
      end
    end
  end

  describe '.create' do
    let(:pipeline_key) do
      'agxzfm1haWxmb29nYWVyOwsSDE9yZ2FuaXphdGlvbiIUa2lzc2tpc3NiYW5rYmFuay5jb2'\
      '0MCxIIV29ya2Zsb3cYgICAkJnrmAoM'
    end

    it 'calls the API' do
      VCR.use_cassette('api_create') do
        box = Streaker::API.new.create_box(
          pipeline_key,
          name: 'Streak test box name'
        )

        expect(box['key']).to be_kind_of(String)
        expect(box['name']).to eq('Streak test box name')
      end
    end
  end
end
