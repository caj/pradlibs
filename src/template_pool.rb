require_relative 'template'

module PradLibs
  class TemplatePool
    def initialize arr
      @members = arr
    end

    def accepts dict
      true
    end

    def generate dict
      Template.new(pick, dict)
    end

    def pick
      raise 'Empty pool' if @members.empty?
      @members.sample
    end
  end
end
