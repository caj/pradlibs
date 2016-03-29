module PradLibs
  class PullRequestTemplateBuilder < Builder
    def initialize pr
      @dict = Dictionary.new
      @pool = PradLibs.load_template_file(File.join(PRADLIBS_TPLS, "pr_template/pr_template.yml"))
      @pr = pr
    end

    def create
      message = create_title @pr
      {
        response_type: :in_channel,
        text: @pr.html_url,
        attachments: [
          {
            fallback: message,
            author_name: @pr.user.login,
            author_link: @pr.user.html_url,
            author_icon: @pr.user.avatar_url,
            title: message,
            title_link: @pr.html_url,
            text: "##{@pr.number}: #{@pr.title}",
          }
        ]
      }
    end

    def create_title pull_request
      @dict = @dict.merge({
        prt: prt
      })

      super
    end

    def prt
      {
        purpose: purpose,
        implementation: implementation,
        has_trello_card?: has_trello_card?
      }
    end

    def body
      @body ||= @pr.body
    end

    def purpose
      body.match(/.*\*Purpose\*([^\*]*)/)[1].strip
    rescue
      nil
    end

    def implementation
      body.match(/.*\*Implementation\*([^\*]*)/)[1].strip
    rescue
      nil
    end

    def trello_card_url
      body.match(/.*\*Trello Card:\*([^\*]*)/)[1].strip
    rescue
      nil
    end

    def has_trello_card?
      !!trello_card_url
    end
  end
end
