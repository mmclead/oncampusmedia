class Hours < ActiveRecord::Base
  belongs_to :school
  attr_accessible :friday_close, :friday_open, :monday_close, :monday_open, :saturday_close, :saturday_open, :sunday_close, :sunday_open, :thursday_close, :thursday_open, :tuesday_close, :tuesday_open, :wednesday_close, :wednesday_open
end
