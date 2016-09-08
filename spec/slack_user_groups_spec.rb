require 'spec_helper'
require 'fakeredis/rspec'

module PradLibs
  describe SlackUserGroups do
    before :each do
      @sug = SlackUserGroups.new
      # @sug.instance_variable_set :@REDIS, @REDIS

      # @REDIS = Redis.new
      Redis.new.hset 'SlackUserGroups', 'fake-team', '<!subteam^S12345678|faketeam>'
    end

    describe 'get slack var' do
      it 'can match vars' do
        expect(@sug.get_slack_var('fake-team')).to eq('<!subteam^S12345678|faketeam>')
      end
    end
  end
end
