class Transactions < ActiveRecord::Base
  belongs_to :school
  attr_accessible :april, :august, :december, :february, :january, :july, :june, :march, :may, :november, :october, :september
end
