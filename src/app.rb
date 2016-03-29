require 'sinatra'
require_relative 'pradlibs'

PRADLIBS_BASE = File.join __dir__, '..'
PRADLIBS_DATA = File.join PRADLIBS_BASE, 'data'
PRADLIBS_TPLS = File.join PRADLIBS_BASE, 'templates'

module PradLibs
  class App < Sinatra::Base
    # curl -H "Content-Type: application/json" -X POST "http://localhost:5000/command" -d "/buzz https://github.com/usertesting/orders/pull/4635"
    post /\/command\/?(pr-only)?/ do
      content_type :json
      pr_only = params[:captures] && params[:captures][0]

      status 200

      text = params[:text]
      @args = Arguments.new(text)
      @args.parse!

      begin
        @mb = if pr_only
                PullRequestTemplateBuilder.new(@args.pr)
              else
                MadlibsBuilder.new(@args.dictionary, @args.templates, @args.pr)
              end

        message = @mb.create
        message.to_json
      rescue
        @args.usage
      end
    end
  end
end
