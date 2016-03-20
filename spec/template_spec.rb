require 'spec_helper'

module PradLibs
  describe Template do
    it 'is initializable with a string' do
      expect(Template.new('')).not_to be_nil
    end

    describe '#to_s' do
      it 'is the titleized version of the given string' do
        expect(Template.new('hear ye hear ye').to_s).to eq 'Hear Ye Hear Ye'
      end

      context 'when dictionary values have been provided' do
        let(:format) { 'These {{pr.commits}} {{adjective}} commits will make your day' }
        let(:dict) do
          Dictionary.new({
            adjective: ['squeaky', 'shaky', 'spotted'],
            pr: {
              id: 1,
              title: 'new-feature',
              comments: 10,
              commits: 5,
              additions: 100,
              deletions: 3,
              changed_files: 2
            }
          })
        end

        it 'interpolates the string value' do
          expect([
            'These 5 Squeaky Commits Will Make Your Day',
            'These 5 Shaky Commits Will Make Your Day',
            'These 5 Spotted Commits Will Make Your Day',
          ]).to include Template.new(format, dict).to_s
        end

        context 'when a placeholder is missing' do
          it 'returns error text containing "!! Lookup Failure !!"' do
            expect(Template.new('Hello {{greeting}}', dict).to_s).to include "!! Lookup Failure !!"
          end

          it 'returns the placeholder for missing nested values' do
            expect(Template.new('Hello {{some.nested.thing}}', dict).to_s).to include "!! Lookup Failure !!"
          end
        end
      end
    end
  end
end
