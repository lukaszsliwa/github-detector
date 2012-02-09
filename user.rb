require 'mongoid'
require 'securerandom'

class User
  include Mongoid::Document

  field :login, type: String
  field :token, type: String

  index :token, unique: true

  before_create :generate_token

  has_many :checkins, :dependent => :destroy

  def generate_token
    self.token = SecureRandom.hex(32)
  end
end
