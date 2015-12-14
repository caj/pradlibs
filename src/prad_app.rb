require 'sinatra'
require_relative 'pradlibs.rb'
Dir[File.join(File.dirname(__FILE__), '**', '*.rb')].each { |f| require f }

class PradApp < Sinatra::Base
  before do
    @pl = PradLibs.new
  end
  post '/command' do
    content_type :json

    status 200

    text = params[:text]
    @pl.process(text).to_json
  end
end
