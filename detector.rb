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

  post '/checkin' do
    authorize!
    Checkin.remove_for_user(@user)
    checkin = @user.checkins.build(:lat => params[:lat], :lng => params[:lng], :message => params[:text])
    if checkin.save
      checkin
    else
      checkin.errors
    end
  end

  get '/geeks' do
    authorize!
    lat, lng = params[:lat], params[:lng]
    radius = params[:radius] || 5000
    # when user missed lat and lng params
    if !params.has_key?(:lat) || !params.has_key?(:lng)
      # get last user's checkin
      @user.checkins.last.tap do |checkin|
        if checkin
          lat, lng = checkin.lat, checkin.lng
        else
          return {}
        end
      end
    end
    result = []
    Checkin.geo_near([lat, lng], :max_distance => 0.0001*radius.to_f, :unit => :km).each do |checkin|
      result << { :lat => checkin.lat, :lng => checkin.lng, :avatar_url => checkin.user.avatar_url, :text => checkin.message, :login => checkin.user.login }
    end
    result
  end
end

