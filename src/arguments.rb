require 'json'

module PradLibs
  class Arguments
    attr_accessor :source, :repo, :repo_name, :pr_number, :options
    attr_reader :dictionary, :templates, :pr

    MATCH_STRING = /https:\/\/github.com\/(.*\/.*)\/pull\/(\d+) ?(.*)?/

    def initialize str = ''
      @source = str
    end

    def parse! str = @source
      return unless str.respond_to? :match

      str.match(MATCH_STRING)

      return unless $~

      @repo_name, @pr_number = $~[1..2]
      @pr_number = @pr_number.to_i
      rawptions = $~[3] || ''
      opt_type = if rawptions.match /^\s*\{.*\}\s*$/
                   'hash'
                 else
                   'string'
                 end

      @options = send "opts_from_#{opt_type}", rawptions
      @dictionary = make_dictionary
      @templates = make_templates
      @pr = PullRequest.for @repo_name, @pr_number
    end

    def usage
      "usage: <link to PR> [string options | JSON options]"
    end

    private

    def make_dictionary
      begin
        if @options[:dictionary]
          dict_files = "#{@options[:dictionary]}.yml"
          dictionary = Dictionary.load_files Dir[File.join PRADLIBS_DATA, dict_files]
        end
      rescue
        dictionary = nil
      end
      dictionary = nil if dictionary.try(:empty?)
      dictionary || default_dictionary
    end

    def make_templates
      begin
        if @options[:templates]
          tpl_files = "#{@options[:templates]}.yml"
          templates = PradLibs.load_template_file File.join(PRADLIBS_TPLS, tpl_files)
        end
      rescue
        templates = nil
      end
      templates || default_templates
    end

    def opts_from_string str
      # implement when there's a need for short args
      nil
    end

    def opts_from_hash hashlike_str
      JSON[hashlike_str].with_indifferent_access
    rescue
      { error: "failed JSON parse: #{hashlike_str}" }
    end

    def default_dictionary
      Dictionary.load_files Dir[File.join PRADLIBS_DATA, '*.yml']
    end

    def default_templates
      PradLibs.load_template_file File.join(PRADLIBS_TPLS, 'madlibs', 'silly.yml')
    end
  end
end
