Dir[File.join(__dir__, '**', '*.rb')].each { |f| require f }

module PradLibs
  def PradLibs.load_template_file(path)
    TemplatePool.new YAML.load_file(path)
  end

  # TODO: Add factory method for composite TemplatePool
end
