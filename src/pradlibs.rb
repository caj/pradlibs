Dir[File.join(__dir__, '**', '*.rb')].each { |f| require_relative f unless f == __FILE__ }
require 'bundler'
Bundler.setup
Bundler.require
require 'yaml'

module PradLibs
  def PradLibs.load_template_file(path)
    TemplatePool.new YAML.load_file(path)
  end

  # TODO: Add factory method for composite TemplatePool
end
