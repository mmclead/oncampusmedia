require "csv"
namespace :importer do
  task :schools => :environment do
    if ENV["SCHOOLS_FILE"].blank?
      puts "Schools file cannot be blank.  Pass SCHOOLS_FILE=<filename> to this method."
    else
      SCHOOLS_FILE = File.new(ENV["SCHOOLS_FILE"]).read.gsub("\r\r","\r")
      index = 0
      CSV.parse(SCHOOLS_FILE, {headers: true}) do |row|
        store_id = row[0]
        school = School.where(store_id: store_id).first
        unless school.present?
          school = School.new
          school.store_id = row[0] 
        end
        school.school_name = row[1]
        school.address = row[2]
        school.dma = row[3]
        school.city = row[4]
        school.state = row[5]
        school.dma_rank = row[12].to_i
        school.school_type = row[10] 
        school.current_local_annual_traffic = row[55]
        school.starbucks =  row[49].present?
        school.coffee_stations = row[50].present?
        school.num_of_screens = row[9].to_i
        
        unless school.school_name.blank?

          demographics = school.demographics
          demographics = Demographics.new unless demographics.present?
          demographics.average_age = row[11].to_i
          demographics.non_resident_alien = row[30].to_f
          demographics.african_american_black = row[31].to_f
          demographics.two_or_more_races = row[32].to_f
          demographics.asian = row[33].to_f
          demographics.hispanic_latino = row[34].to_f
          demographics.white = row[35].to_f
          demographics.unknown = row[36].to_f
          demographics.american_indian_alaskan_native = row[37].to_f
          demographics.native_hawaiian_pacific_islander = row[38].to_f
          demographics.enrollment = row[41].to_i
          school.demographics = demographics
          
          hours = school.hours
          hours = Hours.new unless hours.present?
          hours.monday_open = Time.parse(row[43].to_s.split(" - ")[0]) unless row[43] == "CLOSED" or row[43].blank?
          hours.monday_close = Time.parse(row[43].to_s.split(" - ")[1]) unless row[43] == "CLOSED" or row[43].blank?
          hours.tuesday_open = Time.parse(row[44].to_s.split(" - ")[0]) unless row[44] == "CLOSED" or row[44].blank?
          hours.tuesday_close = Time.parse(row[44].to_s.split(" - ")[1]) unless row[44] == "CLOSED" or row[44].blank?
          hours.wednesday_open = Time.parse(row[45].to_s.split(" - ")[0]) unless row[45] == "CLOSED" or row[45].blank?
          hours.wednesday_close = Time.parse(row[45].to_s.split(" - ")[1]) unless row[45] == "CLOSED" or row[45].blank?
          hours.thursday_open = Time.parse(row[46].to_s.split(" - ")[0]) unless row[46] == "CLOSED" or row[46].blank?
          hours.thursday_close = Time.parse(row[46].to_s.split(" - ")[1]) unless row[46] == "CLOSED" or row[46].blank?
          hours.friday_open = Time.parse(row[47].to_s.split(" - ")[0]) unless row[47] == "CLOSED" or row[47].blank?
          hours.friday_close = Time.parse(row[47].to_s.split(" - ")[0]) unless row[47] == "CLOSED" or row[47].blank?
          hours.saturday_open = Time.parse(row[48].to_s.split(" - ")[0]) unless row[48] == "CLOSED" or row[48].blank?
          hours.saturday_close = Time.parse(row[48].to_s.split(" - ")[0]) unless row[48] == "CLOSED" or row[48].blank?
          hours.sunday_open = Time.parse(row[42].to_s.split(" - ")[0]) unless row[42] == "CLOSED" or row[42].blank?
          hours.sunday_close = Time.parse(row[42].to_s.split(" - ")[1]) unless row[42] == "CLOSED" or row[42].blank?
          school.hours = hours
          
          sports = school.sports
          sports = Sports.new unless sports.present?
          sports.ncaa_basketball_div_i = row[13].present? 
          sports.ncaa_basketball_div_ii = row[14].present?
          sports.ncaa_basketball_div_iii = row[15].present? 
          sports.naia_basketball_div_i_and_ii = row[16].present? 
          sports.ncaa_football_div_i = row[17].present? 
          sports.ncaa_football_div_ii = row[18].present? 
          sports.ncaa_football_div_iii = row[19].present? 
          sports.naia_football_div_i_and_ii = row[20].present? 
          sports.ncaa_baseball_div_i = row[21].present?
          sports.ncaa_baseball_div_ii = row[22].present? 
          sports.ncaa_baseball_div_iii = row[23].present? 
          sports.naia_baseball_div_i_and_ii = row[24].present? 
          sports.ncaa_naia_track_cross_country = row[25].present? 
          sports.njcaa_football_div_i = row[26].present? 
          sports.njcaa_baseball_div_i = row[27].present? 
          sports.njcaa_basketball_div_i = row[28].present? 
          sports.conference = row[29]
          school.sports = sports
          
          schedule = school.schedule
          schedule = Schedule.new unless schedule.present?
          schedule.quarter = row[39].present?
          schedule.semester = row[40].present?
          school.schedule = schedule
          
          puts 'saving school: ' + school.school_name.to_s
          school.save!
          
        else
          puts 'bad data at row' + index.to_s
        end
        index+=1
      end
    end
  end
end
