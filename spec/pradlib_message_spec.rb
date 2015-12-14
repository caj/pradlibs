require 'spec_helper'

describe PradLibMessage do
  let!(:pr) { Octokit.pull_request 'caj/pradlibs', 2 }

  it 'is initializable' do
    expect { PradLibMessage.new pr }.not_to raise_error
  end
end
