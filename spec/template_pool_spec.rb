require 'spec_helper'

module PradLibs
  describe TemplatePool do
    it 'can be inititalized from an Array' do
      expect(TemplatePool.new([])).not_to be_nil
    end

    describe '#pick' do
      context 'empty pool' do
        it 'raises an error' do
          expect { TemplatePool.new([]).pick }.to raise_error 'Empty pool'
        end
      end

      xit 'returns a string from its @members' do

      end
    end
  end
end
