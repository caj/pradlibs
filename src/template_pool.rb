module PradLibs
  class TemplatePool
    def initialize arr
      @members = arr
    end

    def pick
      raise 'Empty pool' if @members.empty?
      @members.sample
    end
  end
end
