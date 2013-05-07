class Demographics < ActiveRecord::Base
  belongs_to :school
  attr_accessible :african_american_black, :american_indian_alaskan_native, :asian, :average_age, :enrollment, :hispanic_latino, :native_hawaiian_pacific_islander, :non_resident_alien, :two_or_more_races, :unknown, :white
  
  
  def percentages
    {
      african_american_black: self.african_american_black, 
      american_indian_alaskan_native: self.american_indian_alaskan_native, 
      asian: self.asian, 
      hispanic_latino: self.hispanic_latino, 
      native_hawaiian_pacific_islander: self.native_hawaiian_pacific_islander, 
      non_resident_alien: self.non_resident_alien, 
      two_or_more_races: self.two_or_more_races, 
      unknown: self.unknown, 
      white:self.white,
      average_age: self.average_age, 
      enrollment: self.enrollment, 
    }
  end
  
end
