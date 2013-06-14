class Import < ActiveRecord::Base
  attr_accessible :schools_file, :transactions_file, :rotc_file, 
                  :schedules_file, :summer_schedules_file
                  :schedules_file, :summer_schedules_file, :schools_import_has_run,
                  :transactions_import_has_run, :rotc_import_has_run,:schedules_import_has_run,
                  :summer_schedules_import_has_run
                  
  serialize :imported_schools
  serialize :imported_transactions
  serialize :imported_rotc 
  serialize :imported_schedules
  serialize :imported_summer_schedules
  has_attached_file :schools_file
  has_attached_file :transactions_file   
  has_attached_file :rotc_file
  has_attached_file :schedules_file
  has_attached_file :summer_schedules_file
  
  
  def files
    list = []
    list.append(schools_file) if schools_file_file_name.present?
    list.append(transactions_file) if transactions_file_file_name.present?
    list.append(rotc_file) if rotc_file_file_name.present?
    list.append(schedules_file) if schedules_file_file_name.present?
    list.append(summer_schedules_file) if summer_schedules_file_file_name.present?
    return list
  end
  
  def headers(file_name)
    text = open(self.send(file_name).url) {|f| f.readlines[0,4] }
    return text
  end
  
end
