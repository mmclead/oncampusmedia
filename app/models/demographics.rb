class Demographics < ActiveRecord::Base
  belongs_to :school
  attr_accessible :african_american_black, :american_indian_alaskan_native, :asian, :average_age, :enrollment, :hispanic_latino, :native_hawaiian_pacific_islander, :non_resident_alien, :two_or_more_races, :unknown, :white
end
