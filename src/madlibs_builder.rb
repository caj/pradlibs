require_relative 'builder'

module PradLibs
  class MadlibsBuilder < Builder
    def create_title
      super.titleize
    end
  end
end
