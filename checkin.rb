require 'mongoid'

class Checkin
  include Mongoid::Document

  belongs_to :user

  validates_presence_of :lng
  validates_presence_of :lat
  validates_presence_of :user

  field :lng, type: BigDecimal
  field :lat, type: BigDecimal
  field :message, type: String

end

