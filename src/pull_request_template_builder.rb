require_relative 'builder'

module PradLibs
  class PullRequestTemplateBuilder < Builder
    def initialize pull_request, slack_params
      @pool = PradLibs.load_template_file(File.join(PRADLIBS_TPLS, "pr_template/pr_template.yml"))
      @pr = pull_request
      @pl = get_pradlibs

      @dict = combine_looker_uppers Dictionary.new
      @slack_params = slack_params.with_indifferent_access
    end

    def create
      message = create_title
      {
        "response_type": :in_channel,
        "attachments": [
          {
            "pretext": "#{@slack_params[:user_name]} requests code review for a PR in the #{@pl[:repo]} repository. <!here>",
            "fallback": "Purpose\n#{purpose}\n\nImplementation\n#{implementation}",
            "title": "#{@pr.title} (+#{@pr.additions} / -#{@pr.deletions})",
            "title_link": @pr.html_url,
            "text": message,
            "color": "#F35A00",
            "mrkdwn_in": [ "text" ]
          }
        ]
      }
    end

    def combine_looker_uppers dict
      dict.merge({
        prt: prt,
        pl: @pl,
        pr: @pr
      })
    end

    def prt
      {
        purpose: purpose,
        implementation: implementation,
        trello_card_url: trello_card_url,
        has_trello_card?: has_trello_card?
      }
    end

    def body
      @body ||= @pr.body
    end

    def purpose
      body.match(/#\s+Purpose(.*)#\s+Implementation/m)[1].strip
    rescue
      nil
    end

    def implementation
      body.match(/#\s+Implementation(.*)#\s+Trello Card/m)[1].strip
    rescue
      nil
    end

    def trello_card_url
      url = body.match(/#\s+Trello Card(.*)/m)[1]
      url.match(/(https:\/\/trello\S+)/)[1].strip
    rescue
      nil
    end

    def has_trello_card?
      !!trello_card_url
    end
  end
end
