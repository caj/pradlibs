require 'active_support/inflector'

module PradLibs
  class Template
    def initialize format, dict = Dictionary.new
      @dict = dict
      @dict.template = format
    end

    def to_s
      @dict.render.titleize
    end
  end
end
