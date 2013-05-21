class Schedule < ActiveRecord::Base
  belongs_to :school
  attr_accessible :fall_finals_first, :fall_finals_last, :fall_first_classes, :quarter, :semester, :spring_finals_first, :spring_finals_last, :spring_first_classes, :summer_first_classes, :summer_finals_first, :summer_finals_last
  
  def hash_for_filter
    {
      term: semester? ? "semester" : quarter? ? "quarter" : nil
    }
    
  end
end
