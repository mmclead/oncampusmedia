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
    (impressions(schools) * cpm).round(2)
  end
  
  def cost_per_spot
    (total_cost /  impressions_per_spot['total'][:total_spots]).round(2)
  end
  
  def cost_per_school
    (total_cost / store_ids.length).round(2)  
  end
  
  def impressions(schools = self.schools)
    impressions = 0
    
    schools.each do |s|
      impressions += (s.transactions.per_week * 2) + (s.num_of_screens > 0 ? ((s.num_of_screens-1) * s.transactions.per_week) : 0)
    end
    
    return impressions
  end
  
  def impressions_per_spot
    per_spot = {}
    schools.each do |s|
      per_spot[s.name] = { 
                          store_id: s.store_id,
                          total_hours_per_week: s.hours.total > 0 ? s.hours.total : 60, 
                          impressions_per_spot: s.hours.total > 0 ? (impressions([s]) / (s.hours.total * spot_length_multiplier)) : 60
                         }
    end
    per_spot["total"] = { total_spots: per_spot.inject(0) {|sum, spot| sum + spot[1][:total_hours_per_week].to_i }  * num_of_weeks.to_f * spot_rate.to_i * spot_length_multiplier  }
    return per_spot
  end
  
  def spot_length_multiplier    
    return (spot_length == 30 ? 1 : spot_length == 15 ? 0.5 : 2) 
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
