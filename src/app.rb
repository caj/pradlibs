require 'sinatra'
require_relative 'pradlibs'

PRADLIBS_BASE = File.join __dir__, '..'
PRADLIBS_DATA = File.join PRADLIBS_BASE, 'data'
PRADLIBS_TPLS = File.join PRADLIBS_BASE, 'templates'

module PradLibs
  class App < Sinatra::Base
    post "/command" do
      content_type :json
      status 200

      # TODO: SLACK TOKEN AUTH

      begin
        pr_only = (params[:command] || '').downcase == "/pr"

        text = params[:text]
        @args = Arguments.new(text)
        @args.parse!
      rescue
        return "Something strange has happened. #{params.inspect}"
      end

      begin
        @mb = if pr_only
                PullRequestTemplateBuilder.new(@args.pr, params)
              else
                MadlibsBuilder.new(@args.dictionary, @args.templates, @args.pr, params)
              end
        message = @mb.create
        message.to_json
      rescue
        @args.usage
      end
    end
  end
end
