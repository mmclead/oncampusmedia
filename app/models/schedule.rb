class Schedule < ActiveRecord::Base
  belongs_to :school
  attr_accessible :fall_finals_first, :fall_finals_last, :first_classes, :quarter, :semester, :spring_finals_first, :spring_finals_last
end
