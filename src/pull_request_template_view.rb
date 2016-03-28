module PradLibs
  class PullRequestTemplateView < Mustache

    attr_accessor :implementation, :purpose, :trello_card_url
    def initialize(pull_request_markdown_string)
      parse_markdown_string(pull_request_markdown_string)
    end

    def has_trello_card?
      @trello_card_url.present?
    end

    private

    def parse_markdown_string(string)
      match_data = string.match( /Purpose(.*)# Implementation(.*)# Trello Card(.*)# Additional/m ).to_a.map(&:strip)
      @purpose = match_data[1]
      @implementation = match_data[2]
      @trello_card_url = match_data[3]
    end
  end
end