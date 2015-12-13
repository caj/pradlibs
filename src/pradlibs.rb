require 'json'
require 'hashie'
require 'awesome_print'
class PradLibs
  def process text
    if prad_valid? text
      message text
    else
      unexpected_message
    end
  end

  def prad_valid? str
    return false unless str
    !!str.match(/https:\/\/github.com\/.*\/.*\/pull\/\d*/)
  end

  def adlibs url
    mash = Hashie::Mash.new(
      JSON.parse(HTTParty.get(GitParser.convert(url)).body)
    )

    Hashie::Mash.new({
      repo: mash.base.repo.name,
      adds: mash.additions,
      dels: mash.deletions,
      net_change: mash.additions - mash.deletions,
      tot_change: mash.additions + mash.deletions,
      comment_count: mash.comments,
      pr_submitter: mash.user.login,
    })
  rescue
    Hashie::Mash.new
  end

  private

  def message text
    payload = adlibs text
    return unexpected_message if payload.empty?
    PradLibMessage.new(payload)
  end

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
      "WUT R U DOIN???",
      "lol cut it out srsly",
      "pssst ---->",
      "No. No, no, no.",
      "readme -->"
    ]
  end
end
