require 'sinatra'
require_relative 'pradlibs'

PRADLIBS_BASE = File.join __dir__, '..'
PRADLIBS_DATA = File.join PRADLIBS_BASE, 'data'
PRADLIBS_TPLS = File.join PRADLIBS_BASE, 'templates'

module PradLibs
  class App < Sinatra::Base
    post '/command' do
      content_type :json

      status 200

      text = params[:text]
      @args = Arguments.new(text)
      @args.parse!

      begin
        message = MadlibsBuilder.new(@args.dictionary, @args.templates, @args.pr).create
        message.to_json
      rescue
        @args.usage
      end
    end
  end
end
