require 'spec_helper'
require 'octokit'

module PradLibs
  describe Builder do

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

      @pool = double() # The template choices
      @mb = Builder.new(@pool, @dict) # SUS
    end

    describe '#create' do
      before do

        expect(@pool).to receive(:accepts).with(@word_bank).and_return true
        expect(@pool).to receive(:generate).with(@word_bank).and_return @template

       # @user = double()
       # allow(@user).to receive(:login).and_return 'Bob'
       # allow(@user).to receive(:html_url).and_return 'http://bob.net'
       # allow(@user).to receive(:avatar_url).and_return 'http://fakeimage.url'
       # @pr = double()
       # allow(@pr).to receive(:user).and_return @user
       # allow(@pr).to receive(:title).and_return 'Fancy PR Title'
       # allow(@pr).to receive(:number).and_return 42
       # allow(@pr).to receive(:html_url).and_return 'http://www.example.com'

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
      before do
        allow(@pool).to receive(:generate).with(@word_bank).and_return @template
        allow(@dict).to receive(:merge).and_return(@word_bank)
      end

      context 'when the pool accepts' do
        it 'gets a title from the pool' do
          expect(@pool).to receive(:accepts).with(@word_bank).and_return true
          expect(@mb.create_title(@pr)).to match /generated message title/i
        end
      end

      context 'when the pool rejects' do
        before do
          expect(@dict).not_to receive(:prepare)
          expect(@pool).not_to receive(:generate)
        end

        it 'uses the pr title' do
          expect(@pool).to receive(:accepts).with(@word_bank).and_return false
          expect(@mb.create_title(@pr)).to eq "DON'T MERGE ME"
        end
      end
    end

    describe '#get_pradlibs' do
      let(:pl) { @mb.get_pradlibs(@pr) }
      it 'returns a hash with some meta parameters' do
        expect(pl[:user]).to be @pr.user.login
        expect(pl[:repo]).to be @pr.base.repo.name
        expect(pl[:total]).to be @pr.additions + @pr.deletions
        expect(pl[:net]).to be (@pr.additions - @pr.deletions)
      end
    end
  end
end
