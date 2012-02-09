require 'grape'
require 'httparty'

class GithubDetector < Grape::API

  helpers do
    def authorize!
      token = params[:token]
      unless token.nil?
        @user = User.where(:token => params[:token]).first
        return true if @user
      end
      error!('401 Unauthorized', 401)
    end
  end

  post '/login' do
    auth = { :username => params[:login], :password => params[:password] }
    party = HTTParty.get('https://api.github.com', :basic_auth => auth)
    if party.response.code == '401'
      error!('401 Unauthorized', 401)
    else
      User.create(:login => params[:login])
    end
  end

  post 'checkin' do
    authorize!
    checkin = @user.checkins.build(:lat => params[:lat], :lng => params[:lng], :message => params[:text])
    if checkin.save
      checkin
    else
      checkin.errors
    end
  end

  get 'geeks' do
    authorize!
    @user
  end
end

