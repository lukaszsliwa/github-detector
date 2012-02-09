require 'mongoid'

class Checkin
  include Mongoid::Document
  include Mongoid::Spacial::Document

  field :location, type: Array, spacial: true

  spacial_index :source

  belongs_to :user

  validates_presence_of :lng
  validates_presence_of :lat
  validates_presence_of :user

  field :message, type: String

  attr_accessible :lng, :lat

  before_save :set_location

  def set_location
    self.location = [self.lat, self.lng]
  end

end

