require 'mongoid'

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("detector")
end

require File.expand_path "../user", __FILE__
require File.expand_path "../checkin", __FILE__
