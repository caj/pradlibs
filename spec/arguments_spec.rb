require 'spec_helper'

module PradLibs
  describe Arguments do
    good_url = "https://github.com/caj/pradlibs/pull/2"
    good_hash_opts = '{ "dictionary": "color",' \
                       '"templates":  "default",' \
                       '}'

    it 'is initializable' do
      expect(Arguments.new).to be_an_instance_of Arguments
    end

    it 'is initializable with string' do
      expect(Arguments.new "yoooo").to be_an_instance_of Arguments
    end

    describe '#usage' do
      it "tells you what you can pass as arguments" do
        expect(Arguments.new.usage).to eq "usage: <link to PR> [string options | JSON options]"
      end
    end

    describe '#parse!' do
      shared_examples_for "a setter of" do |ivar_str, *new_val_plus_maybe_old_val|
        it "#{ivar_str}" do
          ivar_str = "@#{ivar_str}"
          case new_val_plus_maybe_old_val.length
          when 2
            new_val, old_val = new_val_plus_maybe_old_val
            expect { subject.parse! }.to change { subject.instance_variable_get ivar_str }.
              from(old_val).to(new_val)
          when 1
            new_val = new_val_plus_maybe_old_val.first
            expect { subject.parse! }.to change { subject.instance_variable_get ivar_str }.
              to(new_val)
          when 0
            expect { subject.parse! }.to change { subject.instance_variable_get ivar_str }
          else
            fail "weird args yo: #{ivar_str}, #{new_val_plus_maybe_old_val.inspect}"
          end
        end
      end

      shared_examples_for "a non-setter of" do |ivar_str|
        it "#{ivar_str}" do
          ivar_str = "@#{ivar_str}"
          expect { subject.parse! }.not_to change { subject.instance_variable_get ivar_str }
        end
      end

      shared_examples_for "a default-setter of" do |ivar_str|
        it "#{ivar_str}" do
          default_method_name = "default_#{ivar_str}"
          defaults = subject.send default_method_name
          expect { subject.parse! }.to change { subject.send ivar_str }.to eq(defaults)
        end
      end

      context "when initialized with" do
        context "a good url," do
          subject { Arguments.new good_url }

          it_behaves_like "a setter of", "repo_name", 'caj/pradlibs', nil
          it_behaves_like "a setter of", "pr_number", 2, nil

          context "and only that," do
            it_behaves_like "a non-setter of", "options"
            it_behaves_like "a default-setter of", "dictionary"
            it_behaves_like "a default-setter of", "templates"
          end

          context "and a hash with" do
            subject { Arguments.new "#{good_url} #{good_hash_opts}" }

            context "a 'dictionary' key" do
              context "which matches a file name or pattern in the '/data' dir" do
                it_behaves_like "a setter of", "dictionary"
              end

              context "which DOES NOT match a file name or pattern in the '/data' dir" do
                subject { Arguments.new "#{good_url} { \"dictionary\": \"abcdefg\" }" }

                it_behaves_like "a default-setter of", "dictionary"
              end
            end

            context "a 'templates' key" do
              context "which matches a file name in the '/data' dir" do
                it_behaves_like "a setter of", "templates"
              end

              context "which DOES NOT match a file name in the '/data' dir" do
                subject { Arguments.new "#{good_url} { \"templates\": \"abcdefg\" }" }

                it_behaves_like "a default-setter of", "templates"
              end
            end
          end
        end

        context "a bad url" do
          subject { Arguments.new "bad.com" }

          it_behaves_like "a non-setter of", "repo_name"
          it_behaves_like "a non-setter of", "pr_number"
          it_behaves_like "a non-setter of", "options"
          it_behaves_like "a non-setter of", "dictionary"
          it_behaves_like "a non-setter of", "templates"
        end
      end
    end
  end
end
