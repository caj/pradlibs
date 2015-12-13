require 'rspec'
require 'rack/test'
ENV['RACK_ENV'] = 'test'
Dir[File.join(File.dirname(__FILE__), '..', 'src', '*.rb')].each { |f| require f }
