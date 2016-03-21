require 'spec_helper'

module PradLibs
  describe Client do
    let(:good_url) { "https://github.com/caj/pradlibs/pull/2" }
    let(:bad_url) { "i have no idea what im doing" }

    before { @builder = double() }

    it 'is initializable with a builder' do
      expect { Client.new(@builder) }.not_to raise_error
    end

    describe '#prad_valid?' do
      let(:client) { Client.new(@builder) }
      context 'good args' do
        it 'returns true' do
          expect(client.prad_valid? good_url).to be true
        end
      end

      context 'bad args' do
        it 'returns false' do
          expect(client.prad_valid? bad_url).to be false
        end
      end
    end

    describe '#process' do
      let(:client) { Client.new(@builder) }
      context 'good args' do
        it 'returns a generated title' do
          expect(@builder).to receive(:create).and_return({
            text: 'generic message text',
            attachments: [
              {
                title: 'Some Title'
              }
            ]
          })
          expect(client.process(good_url)[:attachments][0][:title]).to eq 'Some Title'
        end
      end
    end

    describe 'integration test' do
      let(:dict) { Dictionary.new({ adjective: ['smelly'] }) }
      let(:pool) { TemplatePool.new ['check out these {{pr.commits}} {{adjective}} commits'] }
      let(:builder) { Builder.new pool, dict }
      let(:client) { Client.new builder }

      it 'generates a title with pr data' do
        expect(client.process(good_url)[:attachments][0][:title]).to eq 'Check Out These 1 Smelly Commits'
      end
    end
  end
end
