require 'spec_helper'

describe GithubDetector do
  describe "POST /login" do

    include Rack::Test::Methods

    it "returns 401 if user doesnt provide proper params" do
      post '/login'
      last_response.status.should == 401
    end

    it "creates a user if the request params are valid" do
      post '/login', :login => 'test_valid_login', :password => 'pass'
      response_mock = mock({:response => { :code => "302" } })
      HTTParty.stub!(:get).and_return(response_mock)
      p last_response
      last_response.status.should == 401
    end
  end
end

