require 'sinatra'

class PradLibs < Sinatra::Base
  post '/' do
    status 200

    text = params[:text]
    unexpected_message unless prad_valid? text
  end

  helpers do
    def usage
      " | usage: <link to PR> [name]"
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

    def prad_valid? str
      false
    end
  end
end
