require 'spec_helper'

describe GitParser do
  describe '#convert' do
    let(:user_pasted) { "https://github.com/caj/pradlibs/pull/1" }
    let(:desired)     { "https://api.github.com/repos/caj/pradlibs/pulls/1" }

    it "converts a user-copied PR URL into an API URL" do
      expect(GitParser.convert user_pasted).to eq desired
    end
  end
end
