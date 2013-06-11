class Import < ActiveRecord::Base
  attr_accessible :schools_file, :transactions_file, :rotc_file, 
                  :schedules_file, :summer_schedules_file
                  
  has_attached_file :schools_file
  has_attached_file :transactions_file   
  has_attached_file :rotc_file
  has_attached_file :schedules_file
  has_attached_file :summer_schedules_file
  
  #after_save :create_and_update_schools
  
  def files
    list = []
    list.append(schools_file) if schools_file_file_name.present?
    list.append(transactions_file) if transactions_file_file_name.present?
    list.append(rotc_file) if rotc_file_file_name.present?
    list.append(schedules_file) if schedules_file_file_name.present?
    list.append(summer_schedules_file) if summer_schedules_file_file_name.present?
    return list
  end
  
  
  
  #def create_and_update_schools
  #  backup = School.backup
    
    
    
  #end
end
