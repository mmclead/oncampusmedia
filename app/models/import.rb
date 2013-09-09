class Import < ActiveRecord::Base
  require 'csv'    
  attr_accessible :schools_file, :transactions_file, :rotc_file, 
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
    text = open(self.send(file_name).url) {|f| f.read.gsub("\r\r","\r").gsub("\n","\r") }
    return text.split("\r")[0,4]
  end
  
  def mark_as_running(type)
    self.send(type+"_import_has_run=", false)
    self.save
  end
  
  def import_files
    files.each {|f| import_file(f.name)}
  end
  
  def import_file(file_name)
    case file_name
      when "schools_file"
        self.imported_schools = import_schools
        self.schools_import_has_run = true
      when "transactions_file"
        self.imported_transactions = import_transactions
        self.transactions_import_has_run = true
      when "schedules_file"
        self.imported_schedules = import_schedules
        self.schedules_import_has_run = true
    end
    self.save
  end
  
  def import_schools
    schools_text = open(schools_file.url) {|f| f.read.gsub("\r\r","\r")}
    index = 0
    new_school_list = []
    updated_school_list = []
    CSV.parse(schools_text.chomp, {headers: true, :row_sep => :auto}) do |row|
      store_id = row[0]
      school = School.where(store_id: store_id).first
      unless school.present?
        school = School.new
        school.store_id = row[0] 
      end
      school.network = row[1].to_s.encode!('UTF-8', 'UTF-8', :invalid => :replace)
      school.school_name = row[2].to_s.encode!('UTF-8', 'UTF-8', :invalid => :replace)
      school.address = row[3].to_s.encode!('UTF-8', 'UTF-8', :invalid => :replace)
      school.city = row[4].to_s.encode!('UTF-8', 'UTF-8', :invalid => :replace)
      school.state = row[5].to_s.encode!('UTF-8', 'UTF-8', :invalid => :replace)
      school.zip = row[6].to_s.encode!('UTF-8', 'UTF-8', :invalid => :replace)
      school.dma = row[7].to_s.encode!('UTF-8', 'UTF-8', :invalid => :replace)
      school.dma_rank = row[8].to_i
      school.num_of_screens = row[9].to_i
      school.school_type = row[10].to_s.encode!('UTF-8', 'UTF-8', :invalid => :replace)
      school.starbucks =  row[48].present?
      school.coffee_stations = row[49].present?
      school.rotc = row[50].present?
      
      unless school.school_name.blank?

        demographics = school.demographics
        demographics = Demographics.new unless demographics.present?
        demographics.average_age = row[11].to_i
        demographics.non_resident_alien = row[29].to_f
        demographics.african_american_black = row[30].to_f
        demographics.two_or_more_races = row[31].to_f
        demographics.asian = row[32].to_f
        demographics.hispanic_latino = row[33].to_f
        demographics.white = row[34].to_f
        demographics.unknown = row[35].to_f
        demographics.american_indian_alaskan_native = row[36].to_f
        demographics.native_hawaiian_pacific_islander = row[37].to_f
        demographics.enrollment = row[40].to_s.gsub(",","").to_i
        school.demographics = demographics
        
        hours = school.hours
        hours = Hours.new unless hours.present?
        unless row[41] == "CLOSED" or row[41].blank?
          t = Time.parse(row[41].to_s.split("-")[0], Time.utc(2000))
          hours.sunday_open = (t + t.gmtoff).getutc
          t = Time.parse(row[41].to_s.split("-")[1], Time.utc(2000))
          hours.sunday_close = (t + t.gmtoff).getutc
        end
        unless row[42] == "CLOSED" or row[42].blank?
          t = Time.parse(row[42].to_s.split("-")[0], Time.utc(2000)) 
          hours.monday_open = (t + t.gmtoff).getutc
          t = Time.parse(row[42].to_s.split("-")[1], Time.utc(2000))        
          hours.monday_close =  (t + t.gmtoff).getutc
        end
        unless row[43] == "CLOSED" or row[43].blank?
          t = Time.parse(row[43].to_s.split("-")[0], Time.utc(2000))
          hours.tuesday_open = (t + t.gmtoff).getutc
          t = Time.parse(row[43].to_s.split("-")[1], Time.utc(2000))
          hours.tuesday_close = (t + t.gmtoff).getutc
        end
        unless row[44] == "CLOSED" or row[44].blank?
          t = Time.parse(row[44].to_s.split("-")[0], Time.utc(2000))
          hours.wednesday_open = (t + t.gmtoff).getutc
          t = Time.parse(row[44].to_s.split("-")[1], Time.utc(2000))
          hours.wednesday_close = (t + t.gmtoff).getutc          
        end
        unless row[45] == "CLOSED" or row[45].blank?
          t = Time.parse(row[45].to_s.split("-")[0], Time.utc(2000))
          hours.thursday_open = (t + t.gmtoff).getutc
          t = Time.parse(row[45].to_s.split("-")[1], Time.utc(2000))
          hours.thursday_close = (t + t.gmtoff).getutc
        end
        unless row[46] == "CLOSED" or row[46].blank?
          t = Time.parse(row[46].to_s.split("-")[0], Time.utc(2000))
          hours.friday_open = (t + t.gmtoff).getutc
          t = Time.parse(row[46].to_s.split("-")[1], Time.utc(2000))
          hours.friday_close = (t + t.gmtoff).getutc
        end
        unless row[47] == "CLOSED" or row[47].blank?
          t = Time.parse(row[47].to_s.split("-")[0], Time.utc(2000))
          hours.saturday_open = (t + t.gmtoff).getutc
          t = Time.parse(row[47].to_s.split("-")[1], Time.utc(2000))
          hours.saturday_close = (t + t.gmtoff).getutc
        end

        school.hours = hours
        
        sports = school.sports
        sports = Sports.new unless sports.present?
        sports.ncaa_basketball_div_i = row[12].present? 
        sports.ncaa_basketball_div_ii = row[13].present?
        sports.ncaa_basketball_div_iii = row[14].present? 
        sports.naia_basketball_div_i_and_ii = row[15].present? 
        sports.ncaa_football_div_i = row[16].present? 
        sports.ncaa_football_div_ii = row[17].present? 
        sports.ncaa_football_div_iii = row[18].present? 
        sports.naia_football_div_i_and_ii = row[19].present? 
        sports.ncaa_baseball_div_i = row[20].present?
        sports.ncaa_baseball_div_ii = row[21].present? 
        sports.ncaa_baseball_div_iii = row[22].present? 
        sports.naia_baseball_div_i_and_ii = row[23].present? 
        sports.ncaa_naia_track_cross_country = row[24].present? 
        sports.njcaa_football_div_i = row[25].present? 
        sports.njcaa_baseball_div_i = row[26].present? 
        sports.njcaa_basketball_div_i = row[27].present? 
        sports.conference = row[28]
        school.sports = sports
        
        schedule = school.schedule
        schedule = Schedule.new unless schedule.present?
        schedule.quarter = row[38].present?
        schedule.semester = row[39].present?
        school.schedule = schedule
        if school.new_record? 
          school.transactions = Transactions.new
          new_school_list.append(school.name)
          sleep(250)  #avoid gmaps OVER_QUERY_LIMIT. when geolocating lots of schools
        elsif (school.changed? or sports.changed? or hours.changed? or demographics.changed?)
          updated_school_list.append({name: school.name, id: school.id, changed_attrs: school.changes.merge(sports.changes).merge(hours.changes).merge(demographics.changes)})  
        end
        school.save!
        
        
      else
        puts 'bad data at row' + index.to_s
      end
      index+=1
    end
    return [new_school_list, updated_school_list]
  end
  
  def import_schedules
    schedule_text = open(schedules_file.url) {|f| f.read.gsub("\r\r","\r")}
    index = 0
    updated_school_list = []
    CSV.parse(schedule_text.chomp, {headers: true}) do |row|
      store_id = row[1]
      school = School.where(store_id: store_id).first
      
      if school.present?
        schedule = school.schedule
        schedule.fall_first_classes = begin Date.try(:strptime, row[1], '%m/%d/%y') rescue nil end
        schedule.fall_finals_first = begin Date.try(:strptime, row[2], '%m/%d/%y') rescue nil end
        schedule.fall_finals_last = begin Date.try(:strptime, row[3], '%m/%d/%y') rescue nil end
        schedule.spring_first_classes = begin Date.try(:strptime, row[4], '%m/%d/%y') rescue nil end
        schedule.spring_finals_first = begin Date.try(:strptime, row[5], '%m/%d/%y') rescue nil end
        schedule.spring_finals_last = begin Date.try(:strptime, row[6], '%m/%d/%y') rescue nil end
        schedule.summer_first_classes = begin Date.try(:strptime, row[7], '%m/%d/%y') rescue nil end
        schedule.summer_finals_first = begin Date.try(:strptime, row[8], '%m/%d/%y') rescue nil end
        schedule.summer_finals_last = begin Date.try(:strptime, row[9], '%m/%d/%y') rescue nil end
        
        updated_school_list.append({name: school.name, id: school.id, changed_attrs: schedule.changes}) if schedule.changed?
        school.save!
      else
        puts 'bad data at row' + index.to_s
      end
      index+=1
    end
    return [[], updated_school_list]
  end
  
  def import_transactions
    transactions_text = open(transactions_file.url) {|f| f.read.gsub("\r\r","\r")}
    index = 0
    updated_school_list = []
    CSV.parse(transactions_text.chomp, {headers: true}) do |row|
      store_id = row[0]
      school = School.where(store_id: store_id).first
      
      if school.present?
        transaction = Transactions.new
        transaction.january = row[1].to_s.gsub(",","").to_i
        transaction.february = row[2].to_s.gsub(",","").to_i
        transaction.march = row[3].to_s.gsub(",","").to_i
        transaction.april = row[4].to_s.gsub(",","").to_i
        transaction.may = row[5].to_s.gsub(",","").to_i
        transaction.june = row[6].to_s.gsub(",","").to_i
        transaction.july = row[7].to_s.gsub(",","").to_i
        transaction.august = row[8].to_s.gsub(",","").to_i
        transaction.september = row[9].to_s.gsub(",","").to_i
        transaction.october = row[10].to_s.gsub(",","").to_i
        transaction.november = row[11].to_s.gsub(",","").to_i
        transaction.december = row[12].to_s.gsub(",","").to_i
        
        school.transactions = transaction
        updated_school_list.append({name: school.name, id: school.id, changed_attrs: transaction.changes}) if transaction.changed?
        school.save!
      else
        puts 'bad data at row' + index.to_s
      end
      index+=1
    end
    return [ [], updated_school_list]
  end
  
end
