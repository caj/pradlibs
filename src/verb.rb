require 'verbs'

module PradLibs
  class Verb
    CONFIG = {
      tense:     [:past,       :present,    :future],
      person:    [:first,      :second,     :third],
      aspect:    [:habitual,   :perfect,    :perfective, :progressive, :prospective],
      mood:      [:indicative, :imperative, :subjunctive],
      plurality: [:singular,   :plural],
    }

    def initialize root, props = {}
      @root = root
      @props = props
    end

    def subject
      lambda do |text|
        with_props({subject: text}).to_s
      end
    end

    def method_missing(name, *args, &block)
      with_props({"#{find_option(name)}": name})
    end

    def respond_to? method
      true unless method == :to_hash
    end

    def to_s
      @root.verb.conjugate @props
    end

    private

    def find_option name
      opt = nil
      CONFIG.each_pair do |k, v|
        opt = k if v.include? name
      end
      opt
    end

    def with_props new_props
      self.class.new(@root, @props.merge(new_props))
    end
  end
end
