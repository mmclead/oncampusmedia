class Transactions < ActiveRecord::Base
  belongs_to :school
  attr_accessible :april, :august, :december, :february, :january, :july, :june, :march, :may, :november, :october, :september
  
  
  def hash_for_filter
    
  end
  
  def total
    sum=0
    Date::MONTHNAMES.compact.each { |month| sum += self.send(month.downcase) }
    return sum
  end
  
  def per_week
    total / 52
  end
  
end
