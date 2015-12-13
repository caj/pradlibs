require 'spec_helper'

describe PradLibs do
  it 'is initializable' do
    expect { PradLibs.new }.not_to raise_error
  end

  describe '#prad_valid?' do
    let(:good_url) { "www.example.com/text/blah/whatever.json" }
    let(:bad_url) { "i have no idea what im doing" }

    context 'good args' do
      it 'returns true' do
        expect(PradLibs.new.prad_valid? good_url).to be true
      end
    end

    context 'bad args' do
      it 'returns false' do
        expect(PradLibs.new.prad_valid? bad_url).to be false
      end
    end
  end
end
