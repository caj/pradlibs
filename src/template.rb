require 'active_support/inflector'

module PradLibs
  class Template
    attr_reader :keywords

    def initialize format, dict = Dictionary.new
      @format = format
      @dict   = dict
      @keywords = parameterize
    end

    def to_s
      (@format % @dict.prepare(keywords)).titleize
    end

    def parameterize
      @format.scan(/%\{([^ ]*)\}/).flatten
    end
  end
end
