require 'spec_helper'

RSpec.describe Streaker::Box do
  describe '#key' do
    it 'returns the initialized key' do
      box = Streaker::Box.new('someboxkey')
      expect(box.key).to eq('someboxkey')
    end
  end

  describe '#update' do
    let(:box) { Streaker::Box.new(key) }

    context 'the key is valid' do
      let(:key) do
        'agxzfm1haWxmb29nYWVyNAsSDE9yZ2FuaXphdGlvbiIUa2lzc2tpc3NiYW5rYmFuay' \
        '5jb20MCxIEQ2FzZRjRkeSNAww'
      end

      it 'updates fields' do
        VCR.use_cassette('box_one_field_update') do
          expect(box.update(fake_field: 'New test field value')).to be_truthy
        end
      end

      it 'updates box owner' do
        VCR.use_cassette('box_owner_update') do
          expect(
            box.update(
              assigned_to: ['kissbot@kisskissbankbank.com'],
            ),
          ).to be_truthy
        end
      end

      it 'changes stage' do
        VCR.use_cassette('box_stage_update') do
          expect(box.update(stage: :fake_stage)).to be_truthy
        end
      end

      it 'changes name' do
        VCR.use_cassette('box_name_update') do
          expect(box.update(name: 'Some Streak test name')).to be_truthy
        end
      end
    end

    context 'the key is invalid' do
      let(:key) do
        'agxzfm1haWxmb29nYWVyNAsSDE9yZ2FuaXphdGlvbiIUa2lzc2tpc3NiYW5rYmFuay5' \
        'jb20MCxIEQ2FzZRihsMPGAQw'
      end

      it 'raises an Streaker::Box::Error if the box has been deleted' do
        VCR.use_cassette('box_not_found_error') do
          expect do
            box.update(fake_field: 'new_test_value')
          end.to raise_error(Streaker::BoxNotFoundError)
        end
      end
    end
  end

  describe '.create' do
    it 'calls the API' do
      VCR.use_cassette('box_create') do
        box = Streaker::Box.create(
          name: 'Streak test box name',
          fake_field: 'Streak test field value',
        )
        expect(box).to be_kind_of(Streaker::Box)
      end
    end
  end
end
