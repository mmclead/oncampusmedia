class Ratecard < ActiveRecord::Base
 
  belongs_to :user
  
  attr_accessible :accept_by, :brand, :cpm, :creative_due_date, :end_date, :flight_date, :num_of_weeks, :prepared_for, :quote_date, :spot_length, :spot_rate, :presented_to, :prepared_by, :store_ids

  serialize :store_ids
  
  validates_presence_of :store_ids, :prepared_for, :brand, :presented_to, :prepared_by, :quote_date, :accept_by, :spot_length, :spot_rate, :flight_date, :end_date, :cpm
  
  after_create :set_dates_and_duration
  
  scope :public_only, where(user_id: nil)
  
  def schools
    store_ids.map {|store_id| School.where(store_id: store_id).first}
  end
  
  def impressions(schools = self.schools)
    impressions = 0
    
    schools.each do |s|
      impressions += (s.transactions.per_week * 2) + ((s.num_of_screens-1) * s.transactions.per_week)
    end
    
    return impressions
  end
  
  def impressions_per_spot
    
    per_spot = {}
    schools.each do |s|
      per_spot[s.name] = { 
                          store_id: s.store_id,
                          total_hours_per_week: s.hours.total, 
                          impressions_per_spot: (impressions([s]) / (s.hours.total * spot_length_multiplier))
                         }
    end
    per_spot["total"] = { total_spots: per_spot.inject(0) {|sum, spot| sum + spot[1][:total_hours_per_week].to_i }  * self.num_of_weeks.to_i * spot_rate.to_i  }
    return per_spot
  end
  
  def spot_length_multiplier    
    return spot_length == 30 ? 1 : spot_length == 15 ? 0.5 : 2
  end
  
  private
  
  def set_dates_and_duration
    self.num_of_weeks = ((self.end_date - self.flight_date)/7.0).to_f
    self.creative_due_date = flight_date - 7.days
    self.save
  end
  

end
