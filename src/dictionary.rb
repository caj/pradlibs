require 'active_support/core_ext/hash/keys'
require 'mustache'

module PradLibs
  class Dictionary < Mustache
    class << self
      def load_file path
        key = File.basename(path, '.yml')
        case key
        when 'verb'
          data = YAML.load_file(path).collect { |v| Verb.new(v) }
        else
          data = YAML.load_file(path)
        end
        Dictionary.new Hash[key, data]
      end

      def load_files paths
        paths.inject Dictionary.new do |dict, f|
          Dictionary.merge(dict, self.load_file(f))
        end
      end

      def merge d1, d2
        Dictionary.new(d1.to_h).merge d2.to_h
      end
    end

    def initialize words = {}
      @words = Hash.new.merge(words).deep_symbolize_keys
    end

    def merge other
      Dictionary.new @words.merge other
    end

    def empty?
      @words.empty?
    end

    def to_h
      @words
    end

    def == o
      o.class == self.class &&
        o.words == self.words
    end

    def [] key
      keys = key.to_s.split('.').map(&:to_sym)
      ret = @words
      failsafe = ''
      while keys.any?
        sub_key = keys.shift
        failsafe << "#{sub_key} "
        ret = context.find ret, sub_key
      end
      if ret
        [*ret].sample
      else
        failsafe.strip
      end
    end

    def method_missing(name, *args, &block)
      if @words.has_key? name
        if @words[name].is_a?(Array)
          @words[name].sample
        else
          @words[name]
        end
      else
        # TODO figure out wtf is going on up in here
        # When the Mustache Template (NOT the local template.rb) renders,
        # it handles everything fine except missing keys.
        #
        # This was put in place along with the [] method to handle
        # that problem, but it still doesn't work for _nested_, missing keys.
        self[name]
      end
    end

    def respond_to?(method)
      true unless method == :to_hash
    end
  end
end
