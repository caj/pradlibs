require 'spec_helper'

describe PradLibMessage do
  let(:mash) do
    Hashie::Mash.new({
      repo: 'cool-repo',
      adds: 10,
      dels: 5,
      net_change: 5,
      tot_change: 15,
      comment_count: 3,
      pr_submitter: 'caj'
    })
  end

  it 'is initializable' do
    expect { PradLibMessage.new mash }.not_to raise_error
  end
end
