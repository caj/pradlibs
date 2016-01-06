require 'active_support/core_ext/hash/keys'
require 'mustache'

module PradLibs
  class Dictionary < Mustache
    def self.load_file path
      key = File.basename(path, '.yml')
      case key
      when 'verb'
        data = YAML.load_file(path).collect { |v| Verb.new(v) }
      else
        data = YAML.load_file(path)
      end
      Dictionary.new Hash[key, data]
    end

    def self.load_files paths
      paths.inject Dictionary.new do |dict, f|
        Dictionary.merge(dict, self.load_file(f))
      end
    end

    def self.merge d1, d2
      Dictionary.new(d1.to_h).merge d2.to_h
    end

    def initialize words = {}
      @words = Hash.new.merge(words).deep_symbolize_keys
    end

    def lookup key
      str = key.to_s
      maybe_array = str.split('/').inject(@words) do |h, k|
        ks = k.to_sym
        if h.respond_to?(:has_key?) && h.has_key?(ks)
          h[k.to_sym]
        # Octokit returns a Sawyer Resource, which uses :key?
        # https://github.com/lostisland/sawyer
        elsif h.respond_to?(:key?) && h.key?(ks)
          h[k.to_sym]
        # pretty up the key if we did not find a value
        else
          key.to_s.tr '/', ' '
        end
      end
      [*maybe_array].sample
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

    def method_missing(name, *args, &block)
      if name =~ /\//
        return lookup(name)
      end
      super unless @words.has_key? name
      return @words[name].sample if @words[name].is_a?(Array)
      @words[name]
    end

    def respond_to?(method)
      true unless method == :to_hash
    end
  end
end
