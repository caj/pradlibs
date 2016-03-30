require 'spec_helper'

module PradLibs
  describe PullRequestTemplateBuilder do
    good_url = "https://github.com/usertesting/orders/pull/4635"

    before :all do
      @args = Arguments.new good_url
      @args.parse!
      @pr = @args.pr
    end

    before :each do
      allow(@pr).to receive(:body).and_return(
        "#{@pr.html_url}
        # Purpose
        here's a purpose, yo

        # Implementation
        we implemented it like this!

        # Trello Card
        and it was related to a link like https://trello.com/card-blah"
      )
    end

    subject { PullRequestTemplateBuilder.new @pr }

    it 'is initializable with a pull request object' do
      expect(subject).to be_a PullRequestTemplateBuilder
    end

    describe '#purpose' do
      it 'is the part of the PR body between *Purpose* and the next *' do
        expect(subject.purpose).to match /here's a purpose, yo\s*/
      end
    end

    describe '#implementation' do
      it 'is the part of the PR body between *Implementation* and the next *' do
        expect(subject.implementation).to match /we implemented it/
      end
    end

    describe '#trello_card_url' do
      it 'is the part of the PR body between *Trello Card:* and the next *' do
        expect(subject.trello_card_url).to match /trello\.com/
      end
    end

    describe '#has_trello_card?' do
      it 'is true if #trello_card_url parsed' do
        expect(subject.has_trello_card?).to be true
      end
    end
  end
end
