require 'httparty'

class GitParser
  class << self
    def convert url
      #                                                          [no trailing '/']
      url.split('/').inject('') { |acc, part| acc += (fix part) }[0..-2]
    end

    private

    def fix str
      case str
      when 'github.com' then 'api.github.com/repos'
      when 'pull'       then 'pulls'
      else str
      end + '/'
    end

  end
end
