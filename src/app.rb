require 'sinatra'
require_relative 'client.rb'
Dir[File.join(File.dirname(__FILE__), '**', '*.rb')].each { |f| require f }

module PradLibs
  class App < Sinatra::Base
    before do
      @pl = PradLibs::Client.new
    end
    post '/command' do
      content_type :json

      status 200

      text = params[:text]
      @pl.process(text).to_json
    end
  end
end
