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
          context 'when the missing value is a single, non-nested key' do
            it 'returns the key' do
              expect(Template.new('Hello {{greeting}}', dict).to_s).to eq 'Hello Greeting'
            end
          end

          # TODO: Make this behave like the single missing placeholder spec,
          #   e.g.
          #        expect(Template.new('Hello {{some.nested.thing}}', dict).to_s).to
          #                         eq 'Hello Some Nested Thing'
          context 'when the missing value is a nested key' do
            it 'quietly does nothing with it' do
              expect(Template.new('Hello {{some.nested.thing}}', dict).to_s).to eq 'Hello '
            end
          end
        end
      end
    end
  end
end
