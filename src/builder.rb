require_relative 'dictionary'

module PradLibs
  class Builder
    def initialize dictionary, template_pool, pull_request, slack_params
      @pool = template_pool
      @pr = pull_request
      @pl = get_pradlibs

      @dict = combine_looker_uppers dictionary
      @slack_params = slack_params.with_indifferent_access
    end

    def create
      message = create_title
      setup_images
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
            thumb_url: get_image,
          }
        ]
      }
    end

    def create_title
      return @pr.title unless @pool.accepts @dict
      CGI.unescapeHTML(@pool.generate(@dict).to_s)
    end

    def get_image
      @images.sample
    end

    def get_pradlibs
      {
        user:  @pr.user.login,
        repo:  @pr.base.repo.name,
        total: @pr.additions + @pr.deletions,
        net:   @pr.additions - @pr.deletions,
      }
    end

    private

    def combine_looker_uppers dict
      dict.merge({
        pr: @pr,
        pl: @pl
      })
    end

    def setup_images
      types = %w(animals architecture nature people tech)
      @images = types.collect { |c| "http://placeimg.com/75/75/#{c}.png" }
    end
  end
end
