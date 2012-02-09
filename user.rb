require 'mongoid'
require 'securerandom'

class User
  include Mongoid::Document

  field :login, type: String
  field :token, type: String
  field :avatar_url, type: String

  index :token, unique: true

  before_create :generate_token
  before_create :get_avatar_url

  has_many :checkins, :dependent => :destroy

  def generate_token
    self.token = SecureRandom.hex(32)
  end

  def get_avatar_url
    party = HTTParty.get("https://api.github.com/users/#{self.login}")
    self.avatar_url =  Crack::JSON.parse(party.response.body)["avatar_url"]
  end

end
