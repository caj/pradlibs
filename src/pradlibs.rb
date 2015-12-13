# ADDING LINES

class PradLibs
  def process text
    unexpected_message unless prad_valid? text
  end

  def prad_valid? str
    return false unless str
    !!str.match(/https:\/\/github.com\/.*\/.*\/pull\/\d*/)
  end

  private

  def usage
    " | usage: <link to PR>"
  end

  def unexpected_message
    unexpected_messages.sample
  end

  def unexpected_messages
    failwords.map { |fw| fw + usage }
  end

  def failwords
    [
      "WUT R U DOIN???", # CHANGING LINES

      #REMOVING LINES
    ]
  end
end
