require 'spec_helper'

describe 'Pull Request Annoyance Delivery Libraries' do
  include Rack::Test::Methods

  def app
    PradApp
  end

  describe "#post" do
    let(:good_url) { "https://github.com/caj/pradlibs/pull/2" }

    it "can recieve a POST request" do
      post '/command'
      expect(last_response).to be_ok
    end

    context "bad args" do
      it "tell the user they're doin' it wrong" do
        post '/command'
        expect(last_response.body).to include 'usage'
      end
    end

    context "good args" do
      it "spits out a buzzfeedish title vaguely related to the PR" do
        post '/command', text: good_url
        expect(last_response.body).to include "in_channel"
      end
    end
  end
end
