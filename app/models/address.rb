class Address < ActiveRecord::Base
  belongs_to :school
  attr_accessible :city, :state, :street
end
