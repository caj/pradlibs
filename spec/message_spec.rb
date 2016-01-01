require 'spec_helper'

module PradLibs
  describe Message do
    let!(:pr) { Octokit.pull_request 'caj/pradlibs', 2 }

    it 'is initializable' do
      expect { Message.new pr }.not_to raise_error
    end
  end
end
