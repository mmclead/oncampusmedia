class Ratecard < ActiveRecord::Base
  attr_accessible :accept_by, :brand, :cpm, :creative_due_date, :end_date, :flight_date, :num_of_weeks, :prepared_for, :quote_date, :spot_length, :spot_rate

  
end
