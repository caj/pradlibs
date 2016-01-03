require 'spec_helper'

module PradLibs
  describe TemplatePool do
    it 'can be inititalized from an array' do
      expect(TemplatePool.new([])).not_to be_nil
    end

    describe '#pick' do
      context 'empty pool' do
        it 'raises an error' do
          expect { TemplatePool.new([]).pick }.to raise_error 'Empty pool'
        end
      end

      it 'returns a string from its @members' do
        words = %w(First Second Third)
        expect(words).to include TemplatePool.new(words).pick
      end
    end

    describe '#accepts' do
      let(:pool) { TemplatePool.new([]) }

      it 'accepts any dictionary' do
        expect(pool.accepts(Dictionary.new)).to be true
      end
    end

    describe '#generate' do
      let(:dict) { Dictionary.new }
      let(:choices) { ['First', 'Second', 'Third'] }

      it 'uses a @member to generate a template' do
        expect([
          'First',
          'Second',
          'Third',
        ]).to include TemplatePool.new(choices).generate(dict).to_s
      end
    end
  end
end
