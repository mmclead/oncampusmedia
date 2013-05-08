class Ratecard < ActiveRecord::Base
  attr_accessible :accept_by, :brand, :cpm, :creative_due_date, :end_date, :flight_date, :num_of_weeks, :prepared_for, :quote_date, :spot_length, :spot_rate

  def calculate_impressions(schools)
    impressions = 0
    
    schools.each do |s|
      impressions += (s.transactions.per_week * 2) + ((s.num_of_screens-1) * s.transactions.per_week)
    end
    
    return impressions
  end
  
  def impressions_per_spot(impressions, schools)
    
    per_spot = {}
    schools.each do |s|
      per_spot[s.name] = { 
                          store_id: s.store_id,
                          total_hours_per_week: s.hours.total, 
                          impressions_per_spot: (calculate_impressions([s]) / (s.hours.total * spot_length_multiplier))
                         }
    end
    
    per_spot["total"] = { total_hours_per_week: per_spot.inject(0) {|sum, spot| sum + spot[1][:total_hours_per_week].to_i } }
    
    return per_spot
  end
  
  def spot_length_multiplier    
    return spot_length == 30 ? 1 : spot_length == 15 ? 0.5 : 2
  end
  
  
end
