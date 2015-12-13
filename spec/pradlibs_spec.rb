require 'spec_helper'

describe PradLibs do
  let(:good_url) { "https://github.com/caj/pradlibs/pull/2" }
  let(:bad_url) { "i have no idea what im doing" }

  it 'is initializable' do
    expect { PradLibs.new }.not_to raise_error
  end

  describe '#prad_valid?' do
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

  describe '#adlibs' do
    context 'good args' do
      it 'extracts the relevant bits from the PR and returns them in a mash' do
        expect(PradLibs.new.adlibs(good_url).keys).to include 'repo'
      end
    end

    context 'bad args' do
      it 'returns an empty mash' do
        expect(PradLibs.new.adlibs(bad_url).keys).to be_empty
      end
    end
  end
end
