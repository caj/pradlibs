require 'spec_helper'
module PradLibs
  describe PullRequestTemplateView do
    let (:pull_request_data) { "foo" }
    let(:pull_request_data) { pull_request_data_string = <<-pullrequeststring
      "# Purpose
        Let Marketing know which users came for App Capture

        # Implementation
        We are already sending info to marketo, so just change it if the account has glimpse_access

        # Trello Card
        http:/www.nowhereville.org

        # Additional Reminders
        - [x] Migrations present? _Add "migration check" label to PR._
        - [x] Needs stack for QA? _Add "deplode" label to PR._
        - [x] Ready for review? _Add "Awaiting CR" label, else add "WIP"._

        # Metrics affected
    pullrequeststring
    }

    subject { PullRequestTemplateView.new(pull_request_data) }

    it "should parse the purpose" do
      expect(subject.purpose).to eq("Let Marketing know which users came for App Capture")
    end

    it "should parse the implementation" do
      expect(subject.implementation).to eq("We are already sending info to marketo, so just change it if the account has glimpse_access")
    end

    it "should parse the trello_card_url" do
      expect(subject.trello_card_url).to eq("http:/www.nowhereville.org")
    end

    describe "#has_trello_card?" do
      context "when there is Trello card information" do
        it "should return true" do
          expect(subject.has_trello_card?).to be_truthy
        end
      end

      context "when there is no Trello card information" do
        let(:pull_request_data) { pull_request_data_string = <<-pullrequeststring
      "# Purpose
        Let Marketing know which users came for App Capture

        # Implementation
        We are already sending info to marketo, so just change it if the account has glimpse_access

        # Trello Card

        # Additional Reminders
        - [x] Migrations present? _Add "migration check" label to PR._
        - [x] Needs stack for QA? _Add "deplode" label to PR._
        - [x] Ready for review? _Add "Awaiting CR" label, else add "WIP"._

        # Metrics affected
        pullrequeststring
        }

        it "should return false" do
          expect(subject.has_trello_card?).to be_falsey
        end
      end
    end
  end
end
