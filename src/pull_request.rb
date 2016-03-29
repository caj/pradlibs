require 'octokit'

module PradLibs
  class PullRequest
    class << self
      def for name, num
        octokit.pull_request(name, num)
      rescue Octokit::InvalidRepository => e
        raise PRNotFound.new "Could not find repository named '#{name.inspect}' with number #{num.inspect}"
      end

      private

      def octokit
        @octokit ||= if ENV['PRADLIBS_ACCESS_TOKEN']
                      Octokit::Client.new access_token: ENV['PRADLIBS_ACCESS_TOKEN']
                     else
                       Octokit::Client.new
                     end
      end
    end
  end
end
