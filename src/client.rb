require 'json'
require 'octokit'
require_relative 'builder'

module PradLibs
  class Client
    def initialize builder
      @builder = builder
    end

    def process text
      if prad_valid? text
        message text
      else
        unexpected_message
      end
    end

    # does it LOOK like a github pr url?
    def prad_valid? str
      return false unless str
      !!parse(str)
    end

    private

    def message text
      repo, num = parse text

      if ENV['PRADLIBS_ACCESS_TOKEN']
        o = Octokit::Client.new access_token: ENV['PRADLIBS_ACCESS_TOKEN']
      else
        o = Octokit::Client.new
      end

      @builder.create o.pull_request repo, num
    end

    def parse str
      str.match /https:\/\/github.com\/(.*\/.*)\/pull\/(\d*)/
      [$~[1], $~[2].to_i] if $~
    end

    def usage
      " | usage: <link to PR>"
    end

    def unexpected_message
      unexpected_messages.sample
    end

    def unexpected_messages
      failwords.map { |fw| fw + usage }
    end

    def failwords
      [
        "WUT R U DOIN???",
        "lol cut it out srsly",
        "pssst ---->",
        "No. No, no, no.",
        "readme -->"
      ]
    end
  end
end
