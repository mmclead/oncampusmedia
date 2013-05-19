class Demographics < ActiveRecord::Base
  belongs_to :school
  attr_accessible :average_age, :enrollment, :african_american_black, :american_indian_alaskan_native, :asian, :hispanic_latino, :native_hawaiian_pacific_islander, :non_resident_alien, :two_or_more_races, :unknown, :white, :latino
  
  
  def hash_for_filter
    {
      average_age: self.average_age, 
      enrollment: self.enrollment, 
      african_american_black: self.african_american_black, 
      american_indian_alaskan_native: self.american_indian_alaskan_native, 
      asian: self.asian, 
      hispanic_latino: self.hispanic_latino, 
      native_hawaiian_pacific_islander: self.native_hawaiian_pacific_islander, 
      non_resident_alien: self.non_resident_alien, 
      two_or_more_races: self.two_or_more_races, 
      unknown: self.unknown, 
      white:self.white
    }
  end
  
  alias_attribute :latino, :hispanic_latino
end
