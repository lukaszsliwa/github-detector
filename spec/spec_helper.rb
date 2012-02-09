require File.expand_path "../../initializer", __FILE__
require File.expand_path "../../detector", __FILE__
require 'rack/test'
include Rack::Test::Methods

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("detector_test")
end

def app
  GithubDetector
end
