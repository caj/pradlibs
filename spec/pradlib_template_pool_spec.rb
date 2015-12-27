require 'spec_helper'

describe PradLibTemplatePool do
  it 'can be inititalized from an Array' do
    expect(PradLibTemplatePool.new([])).not_to be_nil
  end

  describe '#pick' do
    context 'empty pool' do
      it 'raises an error' do
        expect { PradLibTemplatePool.new([]).pick }.to raise_error 'Empty pool'
      end
    end

    xit 'returns a string from its @members' do

    end
  end
end
