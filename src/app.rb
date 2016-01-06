require 'sinatra'
require_relative 'pradlibs'

PRADLIBS_BASE = File.join __dir__, '..'
PRADLIBS_DATA = File.join PRADLIBS_BASE, 'data'
PRADLIBS_TPLS = File.join PRADLIBS_BASE, 'templates'

module PradLibs
  class App < Sinatra::Base
    configure do
      tpls = PradLibs.load_template_file File.join(PRADLIBS_TPLS, 'silly.yml')
      dict = Dictionary.load_files Dir[File.join PRADLIBS_DATA, '*.yml']
      set :pl, Client.new(Builder.new(tpls, dict))
    end

    post '/command' do
      content_type :json

      status 200

      text = params[:text]
      settings.pl.process(text).to_json
    end
  end
end
