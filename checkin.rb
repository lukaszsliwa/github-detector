require 'mongoid'
require 'mongoid_spacial'

class Checkin
  include Mongoid::Document
  include Mongoid::Spacial::Document

  field :location, type: Array, spacial: true

  belongs_to :user

  validates_presence_of :lng
  validates_presence_of :lat
  validates_presence_of :user

  field :message, type: String

  attr_accessible :lng, :lat

  spacial_index :location

  before_save :set_location

  def set_location
    self.location = [self.lat, self.lng]
  end


end

