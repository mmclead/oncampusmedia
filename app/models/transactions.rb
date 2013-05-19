class Transactions < ActiveRecord::Base
  belongs_to :school
  attr_accessible :april, :august, :december, :february, :january, :july, :june, :march, :may, :november, :october, :september
  
  before_save :update_total
  
  def hash_for_filter
    hash = {}
    Date::MONTHNAMES.compact.each {|month| hash["#{month}"] = self.send(month.downcase) } 
    hash["total-transactions"] = total
    return hash
  end
  
  def per_week
    total / 52
  end
  
  private
  
  def update_total
    sum=0
    Date::MONTHNAMES.compact.each { |month| sum += self.send(month.downcase) }
    self.total=sum
  end
end
