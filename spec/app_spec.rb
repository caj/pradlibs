require 'spec_helper'
require 'awesome_print'

module PradLibs
  describe 'Pull Request Annoyance Delivery Libraries' do
    include Rack::Test::Methods

    def app
      App
    end

    describe "#post" do
      let(:good_url) { "https://github.com/caj/pradlibs/pull/2" }
      let(:good_prt_url) { "https://github.com/usertesting/orders/pull/4635" }

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
          ap begin
               JSON.parse(last_response.body)
             rescue
               { ERROR: "FAILED JSON PARSE" }
             end
          expect(last_response.body).to include "in_channel"
        end

        it "has an alternate endpoint" do
          post '/command', text: good_prt_url, command: "/pr"
          ap begin
               JSON.parse(last_response.body)
             rescue
               { ERROR: "FAILED JSON PARSE" }
             end
          expect(last_response.body).to include "in_channel"
        end
      end
    end
  end
end
