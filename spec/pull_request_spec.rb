require 'spec_helper'

module PradLibs
  describe PullRequest do
    describe 'class methods' do
      describe 'for' do
        subject { PullRequest.for "caj/pradlibs", 2 }

        it 'returns a hash for the pull request of the given number for the given repo name' do
          expect(subject).to be_a Sawyer::Resource
          expect(subject.key? :url).to be true
          expect(subject[:url]).to eq "https://api.github.com/repos/caj/pradlibs/pulls/2"
        end
      end
    end
  end
end
