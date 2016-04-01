require_relative 'builder'

module PradLibs
  class PullRequestTemplateBuilder < Builder
    def initialize pr, slack_params
      @dict = Dictionary.new
      @pool = PradLibs.load_template_file(File.join(PRADLIBS_TPLS, "pr_template/pr_template.yml"))
      @pr = pr
      @slack_params = slack_params.with_indifferent_access
    end

    def create
      message = create_title @pr
      {
        "response_type": :in_channel,
        "attachments": [
          {
            "pretext": "#{@slack_params[:user_name]} requests code review for a PR in the #{@pl.repo} repository. <!here>",
            "fallback": "Purpose\n#{purpose}\n\nImplementation\n#{implemaentation}",
            "title": @pr.title,
            "title_link": @pr.html_url,
            "text": message,
            "color": "#F35A00",
            "mrkdwn_in": [ "text" ]
          }
        ]
      }
    end

    def create_title pull_request
      @dict = @dict.merge({
        prt: prt,
        pl: get_pradlibs(pull_request),
        pr: @pr
      })

      super
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
