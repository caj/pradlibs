require 'sinatra'
require_relative 'pradlibs.rb'

class PradApp < Sinatra::Base
  before do
    @pl = PradLibs.new
  end
  post '/' do
    status 200

    text = params[:text]
    @pl.process text
  end
end
