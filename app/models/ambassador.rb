class Ambassador < ActiveRecord::Base
  attr_accessible :address, :city, :name, :state, :zip, :school_ids

  validates_presence_of :address, :city, :name, :state, :zip
  has_and_belongs_to_many :schools

end
