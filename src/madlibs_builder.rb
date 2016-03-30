module PradLibs
  class MadlibsBuilder < Builder
    def create_title pull_request
      super.titleize
    end
  end
end
