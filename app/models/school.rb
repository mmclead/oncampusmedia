class School < ActiveRecord::Base
  attr_accessible :address, :city, :friday_hours, :monday_hours, :num_of_schools, :num_of_schools_included, :saturday_hours, :school_name, :state, :store_id, :sunday_hours, :thursday_hours, :tuesday_hours, :wednesday_hours
  
  acts_as_gmappable
  
  def gmaps4rails_address
    "#{address} #{city}, #{state}"
  end
  
end
