require 'sinatra'
require_relative 'pradlibs'

PRADLIBS_BASE = File.join __dir__, '..'
PRADLIBS_DATA = File.join PRADLIBS_BASE, 'data'
PRADLIBS_TPLS = File.join PRADLIBS_BASE, 'templates'

module PradLibs
  class App < Sinatra::Base
    def templates
      @templates ||= PradLibs.load_template_file File.join(PRADLIBS_TPLS, 'silly.yml')
    end

    def dictionary
      @dictionary ||= Dictionary.load_files Dir[File.join PRADLIBS_DATA, '*.yml']
    end

    def pradlibs
      @pradlibs ||= Client.new(Builder.new(templates, dictionary))
    end

    post '/command' do
      content_type :json

      status 200

      text = params[:text]
      pradlibs.process(text).to_json
    end
  end
end
