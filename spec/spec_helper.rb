require 'rspec'
require 'rack/test'
ENV['RACK_ENV'] = 'test'
Dir[File.join(File.dirname(__FILE__), '..', '*.rb')].each { |f| require f }
