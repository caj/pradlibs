require 'spec_helper'

module PradLibs
  describe Client do
    let(:good_url) { "https://github.com/caj/pradlibs/pull/2" }
    let(:bad_url) { "i have no idea what im doing" }

    it 'is initializable' do
      expect { Client.new }.not_to raise_error
    end

    describe '#prad_valid?' do
      context 'good args' do
        it 'returns true' do
          expect(Client.new.prad_valid? good_url).to be true
        end
      end

      context 'bad args' do
        it 'returns false' do
          expect(Client.new.prad_valid? bad_url).to be false
        end
      end
    end

  end
end
