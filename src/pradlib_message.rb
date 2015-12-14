require 'octokit'

class PradLibMessage
  def initialize octokit
    @pr = octokit
    ap @pr
  end
end

REGULAR_MESSAGES = [

]
