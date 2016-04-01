require 'spec_helper'
require 'octokit'

module PradLibs
  describe Builder do
    good_url = "https://github.com/caj/pradlibs/pull/2"
    params =
      {
        token:       "example token",
        team_id:     "T0000",
        team_domain: "example domain",
        channel_id:   "C0000000000",
        channel_name: "code_review",
        user_id:      "U0000000000",
        user_name:    "User",
        command:      "/buzz",
        text:         good_url,
        response_url: "www.example.com"
      }

    test_dict = Dictionary.new({ testing: "success!" })
    test_pool = TemplatePool.new ["Testing status: {{testing}}"]

    before(:all) do
      # TODO save an Arguments obj's state and use that instead of making a request
      @args = Arguments.new(good_url)
      @args.parse!
      @pr = @args.pr
    end

    before do
      @mb = Builder.new(test_dict, test_pool, @pr, params)
    end

    describe '#create' do
      it 'creates a message hash from a PR' do
        expect(@mb.create).to be_a Hash
      end

      it 'returns a hash with [:response_type] = :in_channel' do
        expect(@mb.create[:response_type]).to eq :in_channel
      end

      it 'returns the PR link as the message text' do
        expect(@mb.create[:text]).to eq @pr.html_url
      end

      context 'with optional arguments' do
        xit 'placeholder for when args are added' do
          expect(true).to be false
        end
      end

      describe "[:attachments][0]" do
        before do
          @attachments = @mb.create[:attachments][0]
        end

        it 'has a fallback field' do
          expect(@attachments[:fallback]).not_to be_nil
        end

        it 'has an author_name field' do
          expect(@attachments[:author_name]).to eq @pr.user.login
        end

        it 'has an author_link field' do
          expect(@attachments[:author_link]).to eq @pr.user.html_url
        end

        it 'has an author_icon field' do
          expect(@attachments[:author_icon]).to eq @pr.user.avatar_url
        end

        it 'has a title field' do
          expect(@attachments[:title]).to eq 'Testing status: success!'
        end

        it 'has a title_link field' do
          expect(@attachments[:title_link]).to eq @pr.html_url
        end

        it 'has the PR number in the text field' do
          expect(@attachments[:text]).to include @pr.number.to_s
        end

        it 'has the PR title in the text field' do
          expect(@attachments[:text]).to include @pr.title
        end

        it 'has a thumb_url field' do
          expect(@attachments[:thumb_url]).to match /http:\/\/placeimg.com\/75\/75\/([a-z]+)\.png/
        end
      end
    end

    describe '#create_title' do
      context 'when the pool accepts' do
        it 'gets a title from the pool' do
          expect(@mb.create_title @pr).to match /success!/i
        end
      end

      context 'when the pool rejects' do
        before do
          expect(test_pool).not_to receive(:generate)
        end

        it 'uses the pr title' do
          expect(test_pool).to receive(:accepts).at_least(:once).and_return false
          expect(@mb.create_title @pr).to eq "DON'T MERGE ME"
        end
      end
    end

    describe '#get_pradlibs' do
      let(:pl) { @mb.get_pradlibs @pr }
      it 'returns a hash with some meta parameters' do
        expect(pl[:user]).to be @pr.user.login
        expect(pl[:repo]).to be @pr.base.repo.name
        expect(pl[:total]).to be @pr.additions + @pr.deletions
        expect(pl[:net]).to be (@pr.additions - @pr.deletions)
      end
    end
  end
end
