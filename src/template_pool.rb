require_relative 'template'

module PradLibs
  class TemplatePool
    attr_reader :members

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

    def == o
      o.class == self.class &&
        o.members == self.members
    end
  end
end
