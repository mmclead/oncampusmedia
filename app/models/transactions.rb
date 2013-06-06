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
  
  def for_period(start_date, end_date)
    months_between = (end_date.year * 12 + end_date.month) - (start_date.year * 12 + start_date.month)
    total = 0
    if months_between > 0
      total+= self.send(start_date.strftime('%B').downcase) * 
              ((((Date.new(start_date.year, start_date.next_month.month)-1).mday - start_date.mday)+1).to_f / 
              (Date.new(start_date.year, start_date.next_month.month)-1).mday).to_f
      total+= self.send(end_date.strftime('%B').downcase) * 
              (end_date.mday.to_f / (Date.new(end_date.year, end_date.next_month.month)-1).mday).to_f
      if months_between > 1
        this_month = start_date
        (months_between-1).times do 
          this_month = this_month.next_month
          total += self.send(this_month.strftime('%B').downcase)
        end
      end
      
    else
      
      total+= self.send(start_date.strftime('%B').downcase) * 
              (((end_date.mday - start_date.mday)+1).to_f / 
              (Date.new(start_date.year, start_date.next_month.month)-1).mday).to_f
    end
    return total
  end
  
  private
  
  def update_total
    sum=0
    Date::MONTHNAMES.compact.each { |month| sum += self.send(month.downcase).to_i }
    self.total=sum
  end
end
