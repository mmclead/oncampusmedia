require "csv"
namespace :importer do
  task :schedules => :environment do
    if ENV["SCHEDULES_FILE"].blank?
      puts "Schedules file cannot be blank.  Pass SCHEDULES_FILE=<filename> to this method."
    else
      SCHEDULES_FILE = File.new(ENV["SCHEDULES_FILE"]).read.gsub("\r\r","\r")
      index = 0
      CSV.parse(SCHEDULES_FILE, {headers: true}) do |row|
        store_id = row[1]
        school = School.where(store_id: store_id).first
        
        if school.present?
          schedule = school.schedule
          schedule.spring_finals_first = begin Date.try(:strptime, row[3], '%m/%d/%y') rescue nil end
          schedule.spring_finals_last = begin Date.try(:strptime, row[4], '%m/%d/%y') rescue nil end
          schedule.fall_first_classes = begin Date.try(:strptime, row[5], '%m/%d/%y') rescue nil end
          schedule.fall_finals_first = begin Date.try(:strptime, row[6], '%m/%d/%y') rescue nil end
          schedule.fall_finals_last = begin Date.try(:strptime, row[7], '%m/%d/%y') rescue nil end
          
          puts 'saving school: ' + school.name.to_s 
          school.save!
        else
          puts 'bad data at row' + index.to_s
        end
        index+=1
      end
    end
  end
end