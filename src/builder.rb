require_relative 'dictionary'

module PradLibs
  class Builder
    def initialize dictionary, template_pool, pull_request
      @dict = dictionary
      @pool = template_pool
      @pr = pull_request
      setup_images
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
            thumb_url: get_image,
          }
        ]
      }
    end

    def create_title pull_request
      word_bank = @dict.merge({
        pr: pull_request,
        pl: get_pradlibs(pull_request)
      })
      return pull_request.title unless @pool.accepts word_bank
      @pool.generate(word_bank).to_s
    end

    def get_image
      @images.sample
    end

    def get_pradlibs pull_request
      {
        user:  pull_request.user.login,
        repo:  pull_request.base.repo.name,
        total: pull_request.additions + pull_request.deletions,
        net:   pull_request.additions - pull_request.deletions,
      }
    end

    def setup_images
      types = %w(animals architecture nature people tech)
      @images = types.collect { |c| "http://placeimg.com/75/75/#{c}.png" }
    end

    private :setup_images
  end
end
