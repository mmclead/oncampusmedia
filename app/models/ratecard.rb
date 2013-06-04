class Ratecard < ActiveRecord::Base
 
  belongs_to :user
  
  attr_accessible :accept_by, :brand, :cpm, :creative_due_date, 
                  :end_date, :flight_date, :num_of_weeks, :prepared_for, 
                  :quote_date, :spot_length, :spot_rate, :presented_to, 
                  :prepared_by, :store_ids, :special_instructions, :additional_cost

  serialize :store_ids
  
  validates_presence_of :store_ids, :prepared_for, :brand, :presented_to, :prepared_by, :quote_date, :accept_by, :creative_due_date, :spot_length, :spot_rate, :flight_date, :end_date, :cpm
  
  after_create :email_pdf_to_creator
    
  before_save :set_dates_and_duration
  
  scope :public_only, where(user_id: nil)
  scope :owned, where("user_id != ?", nil)
  #scope :public_and_mine, lambda { |user_id| public_only.or(self.arel_table[:user_id].eq(user_id) ) }
  
  
  def self.public_and_mine(user_id)
    r = self.arel_table
    self.where(r[:user_id].eq(nil).or(r[:user_id].eq(user_id)))
  end
  
  def schools
    School.where(store_id: store_ids)
  end
  
  def total_cost(schools = self.schools)
    schools.inject(0) {|sum, school| sum + cost_at_school(school)[:total_cost] } + additional_cost.to_f
  end
  
  def cost_per_spot(schools = self.schools)
    schools.inject(0) {|sum, school| sum + cost_at_school(school)[:cost_per_spot] } / schools.size
  end
  
  def cost_per_school(schools = self.schools)
    total_cost(schools) / schools.size
  end
  
  def cost_at_school(school)
    dwell_time = Equation.first.dwell_time
    actual_impressions = total_impressions([school]) / dwell_time
    total_cost = (actual_impressions / 1000) * cpm 
    cost_per_spot = total_cost / total_spots([school])
    return {cost_per_spot: cost_per_spot, total_cost: total_cost }
  end
  
  def total_impressions(schools = self.schools)
    impressions = 0
    equation = Equation.first
    schools.each do |s|
      impressions += s.transactions.for_period(flight_date, end_date)  * s.screen_multiplier(equation.screen_weight_multiplier) 
    end
    return impressions * equation.impression_factor * spot_length_multiplier * spot_rate
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
    spot_length/30.to_f
    #(spot_length == 30 ? 1 : spot_length == 15 ? 0.5 : 2) 
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
    #self.creative_due_date = flight_date - 7.days
  end
  
  def email_pdf_to_creator
    if self.user.present?
      UserMailer.send_pdf_of_quote(self).deliver
    end
  end
  
end
