module PradLibs
  class Builder
    def initialize pool
      @pool = pool
    end

    def create pr
      message = create_title pr
      {
        response_type: :in_channel,
        text: pr.html_url,
        attachments: [
          {
              fallback: message,
              author_name: pr.user.login,
              author_link: pr.user.html_url,
              author_icon: pr.user.avatar_url,
              title: message,
              title_link: pr.html_url,
              text: "##{pr.number}: #{pr.title}",
              #thumb_url: get_image,
          }
        ]
      }
    end

    def create_title pr
      @pool.pick
    end
  end
end
