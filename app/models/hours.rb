class Hours < ActiveRecord::Base
  belongs_to :school
  attr_accessible :friday_close, :friday_open, :monday_close, :monday_open, :saturday_close, :saturday_open, :sunday_close, :sunday_open, :thursday_close, :thursday_open, :tuesday_close, :tuesday_open, :wednesday_close, :wednesday_open
  
  
  
  def total
    total = 0
    Date::DAYNAMES.each {|day| total+= hours_for(day.downcase)}
    total.abs
  end
  
  def hours_for(day)
    open = "#{day}_open"
    close = "#{day}_close"
    if self.send(close).present? and self.send(open).present?
      (self.send(close) - self.send(open)) / 3600
    else
      0
    end
  end
end
