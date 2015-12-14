require 'spec_helper'

describe 'Pull Request Annoying Delivery Libraries' do
  include Rack::Test::Methods

  def app
    PradApp
  end

  describe "#post" do
    it "can recieve a POST request" do
      post '/'
      expect(last_response).to be_ok
    end

    context "bad args" do
      it "tell the user they're doin' it wrong" do
        post '/'
        expect(last_response.body).to include 'usage'
      end
    end

    context "good args" do
      xit "spits out a buzzfeedish title vaguely related to the PR" do
      end
    end
  end
end
