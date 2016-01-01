require 'spec_helper'

module PradLibs
  describe Builder do
    before do
      @pool = double()
      @mb = Builder.new @pool
    end

    describe '#create' do
      before do
        allow(@pool).to receive(:pick).and_return 'Message Title'
        @pr = double()
        @user = double()
        allow(@user).to receive(:login).and_return 'Bob'
        allow(@user).to receive(:html_url).and_return 'http://bob.net'
        allow(@user).to receive(:avatar_url).and_return 'http://fakeimage.url'
        allow(@pr).to receive(:user).and_return @user
        allow(@pr).to receive(:title).and_return 'Fancy PR Title'
        allow(@pr).to receive(:number).and_return 42
        allow(@pr).to receive(:html_url).and_return 'http://www.example.com'
        @attachments = @mb.create(@pr)[:attachments][0]
      end

      it 'creates a message hash from a PR' do
        expect(@mb.create(@pr)).to be_a Hash
      end

      it 'returns a hash with [:response_type] = :in_channel' do
        expect(@mb.create(@pr)[:response_type]).to eq :in_channel
      end

      it 'returns the PR link as the message text' do
        expect(@mb.create(@pr)[:text]).to eq 'http://www.example.com'
      end

      describe "[:attachments][0]" do
        it 'has a fallback field' do
          expect(@attachments[:fallback]).not_to be_nil
        end

        it 'has an author_name field' do
          expect(@attachments[:author_name]).to eq 'Bob'
        end

        it 'has an author_link field' do
          expect(@attachments[:author_link]).to eq 'http://bob.net'
        end

        it 'has an author_icon field' do
          expect(@attachments[:author_icon]).to eq 'http://fakeimage.url'
        end

        it 'has a title field' do
          expect(@attachments[:title]).to eq 'Message Title'
        end

        it 'has a title_link field' do
          expect(@attachments[:title_link]).to eq 'http://www.example.com'
        end

        it 'has the PR number in the text field' do
          expect(@attachments[:text]).to include '42'
        end

        it 'has the PR title in the text field' do
          expect(@attachments[:text]).to include 'Fancy PR Title'
        end

        xit 'has a thumb_url field' do
        end
      end
    end

    describe '#create_title' do
      before do
        allow(@pool).to receive(:pick).and_return 'Test String'
      end

      it 'gets the title from a pool' do
        expect(@mb.create_title(@pr)).to eq 'Test String'
      end
    end
  end
end
