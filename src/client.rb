require 'json'
require 'octokit'
require_relative 'madlibs_builder'

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
      repo, num, args = parse text

      if ENV['PRADLIBS_ACCESS_TOKEN']
        o = Octokit::Client.new access_token: ENV['PRADLIBS_ACCESS_TOKEN']
      else
        o = Octokit::Client.new
      end

      @builder.create o.pull_request(repo, num), args
    end

    def parse str
      str.match /https:\/\/github.com\/(.*\/.*)\/pull\/(\d+) ?(.*)?/
      additional_args = begin
                          JSON.parse($~[3])
                        rescue JSON::ParserError  # oops it wasn't a hash
                          $~[3]
                        rescue NoMethodError # oops it wasn't even present
                          nil
                        end

      [$~[1], $~[2].to_i, additional_args] if $~
    end

    def usage
      " | usage: <link to PR>"
    end

    def unexpected_message
      unexpected_messages.sample
    end

    def unexpected_messages
      @unexpected_messages ||= failwords.map { |fw| fw + usage }
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
