require 'spec_helper'
module PradLibs
  describe PullRequestTemplateBuilder do

    before(:all) do
      if ENV['PRADLIBS_ACCESS_TOKEN']
        o = Octokit::Client.new access_token: ENV['PRADLIBS_ACCESS_TOKEN']
      else
        o = Octokit::Client.new
      end

      @pr = o.pull_request 'caj/pradlibs', 2
    end

    before do
      @template = double() # The object containing the title
      allow(@template).to receive(:to_s).and_return 'Generated Message Title'
      allow(@template).to receive(:base)

      @dict = double() # initial dictionary
      @word_bank = double() # dict with pr included

      @mb = PullRequestTemplateBuilder.new(@dict)
    end

    describe '#create' do
      before do
        expect(@dict).to receive(:merge).and_return(@word_bank)
      end

      it 'creates a message hash from a PR' do
        expect(@mb.create(@pr)).to be_a Hash
      end

      it 'returns a hash with [:response_type] = :in_channel' do
        expect(@mb.create(@pr)[:response_type]).to eq :in_channel
      end

      it 'returns the PR link as the message text' do
        expect(@mb.create(@pr)[:text]).to eq @pr.html_url
      end

      context 'with optional arguments' do
        xit 'placeholder for when args are added' do
          expect(true).to be false
        end
      end

      describe "[:attachments][0]" do
        before do
          @attachments = @mb.create(@pr)[:attachments][0]
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
          expect(@attachments[:title]).to eq 'Generated Message Title'
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
      it "should return the title of the PR" do
        expect(@mb.create_title).to eq(@pr[:title])
      end
    end
  end
end