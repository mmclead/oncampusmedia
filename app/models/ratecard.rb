class Ratecard < ActiveRecord::Base
 
  belongs_to :user
  
  attr_accessible :accept_by, :brand, :cpm, :creative_due_date, :end_date, :flight_date, :num_of_weeks, :prepared_for, :quote_date, :spot_length, :spot_rate, :presented_to, :prepared_by, :store_ids

  serialize :store_ids
  
  validates_presence_of :store_ids, :prepared_for, :brand, :presented_to, :prepared_by, :quote_date, :accept_by, :spot_length, :spot_rate, :flight_date, :end_date, :cpm
  
  after_create :set_dates_and_duration, :email_pdf_to_creator
    
  scope :public_only, where(user_id: nil)
  
  def schools
    store_ids.map {|store_id| School.where(store_id: store_id).first}
  end
  
  def total_cost(schools = self.schools)
    schools.inject(0) {|sum, school| sum + cost_at_school(school)[:total_cost] }
  end
  
  def cost_per_spot(schools = self.schools)
    schools.inject(0) {|sum, school| sum + cost_at_school(school)[:cost_per_spot] } / schools.size
  end
  
  def cost_per_school(schools = self.schools)
    total_cost(schools) / schools.size
  end
  
  def cost_at_school(school)
    weighted_impressions_per_hour = weekly_impressions([school]) / weekly_hours([school])
    dwell_time = 3
    actual_impressions_per_hour = weighted_impressions_per_hour / dwell_time
    cost_per_spot = actual_impressions_per_hour / 1000 * cpm * spot_rate 
    total_cost = cost_per_spot * total_spots([school])
    return {cost_per_spot: cost_per_spot, total_cost: total_cost }
  end
  
  def weekly_impressions(schools = self.schools)
    impressions = 0
    schools.each do |s|
      impressions += ((s.transactions.per_week * 2) + (s.num_of_screens > 0 ? ((s.num_of_screens-1) * 0.5 * s.transactions.per_week) : 0)) * spot_length_multiplier
    end
    return impressions
  end
  
  def total_impressions(schools = self.schools)
    weekly_impressions(schools) * num_of_weeks
  end
  
  def total_spots(schools = self.schools)
    spot_rate * hours_in_period(schools)
  end
  
  def hours_in_period(schools = self.schools)
     num_of_weeks * weekly_hours(schools)
  end
  
  def weekly_hours(schools = self.schools)
    schools.inject(0) {|sum, school| sum + school.hours.total.to_i }
  end
  
  def spot_length_multiplier    
    (spot_length == 30 ? 1 : spot_length == 15 ? 0.5 : 2) 
  end
  
  def impressions_per_spot
    per_spot = {}
    schools.each do |s|
      per_spot[s.name] = { 
                          store_id: s.store_id,
                          total_hours_per_week: s.hours.total,
                          impressions_per_spot: (impressions([s]) / s.hours.total )
                         }
    end
    per_spot["total"] = { total_spots: (per_spot.inject(0) {|sum, spot| sum + spot[1][:total_hours_per_week].to_i }  * num_of_weeks.to_f * spot_rate.to_i ).to_i  }
    return per_spot
  end
  private
  
  def set_dates_and_duration
    self.num_of_weeks = ((self.end_date - self.flight_date)/7.0).to_f
    self.creative_due_date = flight_date - 7.days
    self.save
  end
  
  def email_pdf_to_creator
    if self.user.present?
      UserMailer.send_pdf_of_quote(self).deliver
    end
  end
  
end
