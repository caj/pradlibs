require 'redis'

module PradLibs
  class SlackUserGroups
    REDIS_KEY = 'SlackUserGroups'

    def initialize
      redis_url = ENV['REDISTOGO_URL']
      if !redis_url.nil?
        uri = URI.parse(redis_url)
        @redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
      else
        @redis = Redis.new
      end
    end

    def get_slack_var(github_team_name)
      @redis.hget(REDIS_KEY, github_team_name)
    end
  end
end
