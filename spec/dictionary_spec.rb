require 'spec_helper'

module PradLibs
  describe Dictionary do
    let(:dict) do
      Dictionary.new({
        number: 9,
        'foo' => 'bar!',
        'wizard' => ['Gandalf', 'Dumbledore', 'Merlin'],
        'nest' => {
          'thing' => 5,
          another_thing: 10
        },
        pos: {
          noun: [ 'chair', 'table', 'toaster'],
        },
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

    it 'is initializable' do
      expect(Dictionary.new).not_to be_nil
    end

    describe '#[]' do
      context 'on a simple key' do
        it 'works with string keys' do
          expect(dict.[] 'foo').not_to be_nil
        end

        it 'works with symbol keys' do
          expect(dict.[] :foo).not_to be_nil
        end

        it 'returns the value of a key' do
          expect(dict.[] 'foo').to eq 'bar!'
          expect(dict.[] 'number').to be 9
        end

        it 'samples an array value' do
          expect(%w(Gandalf Dumbledore Merlin)).to include dict.[]('wizard')
        end
      end

      context 'on a compound key' do
        it 'correctly returns a value' do
          expect(dict.[](:"nest.thing")).to be 5
          expect(dict.[]('nest.another_thing')).to be 10
          expect(['chair', 'table', 'toaster']).to include dict.[]('pos.noun')
          expect(dict.[]('pr.commits')).to be 5
        end
      end

      context 'when a value is missing' do
        it 'returns the key as a string' do
          expect(dict.[]('nards')).to eq 'nards'
        end

        it 'returns the compound key as a string' do
          expect(dict.[]('some.thing')).to eq 'some thing'
          expect(dict.[]('nest.a_key')).to eq 'nest a_key'
        end
      end
    end

    describe '#merge' do
      let(:adverbs) { ['quietly', 'quickly', 'quizzically'] }
      let(:more_words) { { adverb: adverbs } }

      it 'can return a new Dictionary with additional keys' do
        expect(adverbs).to include dict.merge(more_words)['adverb']
        expect(dict['foo']).to eq 'bar!'
      end
    end

    describe '#empty?' do
      it 'is true when the words hash is empty' do
        expect(Dictionary.new.empty?).to be true
      end

      it 'is false when the words hash is non-empty' do
        expect(Dictionary.new({foo: 'bar'}).empty?).to be false
      end
    end

    describe '#to_h' do
      it 'returns the internal words hash' do
        words = { noun: %w(couch table chair) }
        expect(Dictionary.new(words).to_h).to eq words
      end

      it 'returns the symbolized internal words hash' do
        words = { 'foo' => %w(bar bat baz) }
        expect(Dictionary.new(words).to_h).to eq({foo: %w(bar bat baz)})
      end
    end

    describe '::load_file' do
      let(:fixture) do
        {
          pos: {
            noun: %w(couch table chair ottoman),
            verb: %w(run swim jump catch)
          }
        }
      end

      it 'creates a dictionary from a YAML file' do
        parts = File.join __dir__, 'fixtures', 'pos.yml'
        expect(Dictionary.load_file(parts).is_a? Dictionary).to be true
      end

      it 'creates a dictionary containing the YAML file' do
        parts = File.join __dir__, 'fixtures', 'pos.yml'
        expect(Dictionary.load_file(parts).to_h).not_to be_empty
      end

      it 'uses the filename as the hash key for YAML arrays' do
        nouns = File.join __dir__, 'fixtures', 'parts', 'noun.yml'
        expect(Dictionary.load_file(nouns).to_h).to eq({noun: fixture[:pos][:noun]})
      end
    end

    describe '::load_files' do
      let(:fixture) do
        {
          noun: %w(couch table chair ottoman),
          verb: %w(run swim jump catch)
        }
      end

      let(:paths) { Dir[File.join __dir__, 'fixtures', 'parts', '*.yml'] }

      it 'creates a dictionary from an array of file paths' do
        expect(Dictionary.load_files(paths).is_a? Dictionary).to be true
      end

      it 'contains data from all loaded files' do
        actual = Dictionary.load_files(paths).to_h
        adjusted = actual.inject({}) do |acc, (k, v)|
          if v.all? { |x| x.is_a? Verb }
            acc.merge k => v.map { |x| x.instance_variable_get :@root }
          else
            acc.merge  k => v
          end
        end
        expect(adjusted).to eq fixture
      end
    end

    describe '::merge' do
      let(:h1) { Hash[:noun, %w(couch table chair)] }
      let(:h2) { Hash[:verb, %w(run swim jump)] }
      let(:expected) { { noun: %w(couch table chair), verb: %w(run swim jump) } }

      it 'merges a two hashes' do
        expect(Dictionary.merge(h1, h2).to_h).to eq expected
      end

      it 'merges a dictionary with a hash' do
        d1 = Dictionary.new h1
        expect(Dictionary.merge(d1, h2).to_h).to eq expected
      end

      it 'merges two dictionaries' do
        d1 = Dictionary.new h1
        d2 = Dictionary.new h2
        expect(Dictionary.merge(d1, d2).to_h).to eq expected
      end
    end
  end
end
