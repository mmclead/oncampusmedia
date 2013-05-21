require "csv"
namespace :importer do
  task :summerschedules => :environment do
    if ENV["SUMMER_FILE"].blank?
      puts "Schedules file cannot be blank.  Pass SUMMER_FILE=<filename> to this method."
    else
      SUMMER_FILE = File.new(ENV["SUMMER_FILE"]).read.gsub("\r\r","\r")
      index = 0
      CSV.parse(SUMMER_FILE, {headers: true}) do |row|
        store_id = row[0]
        school = School.where(store_id: store_id).first
        
        if school.present?
          schedule = school.schedule
          schedule.summer_first_classes = begin Date.try(:strptime, row[2], '%m/%d/%y') rescue nil end
          schedule.summer_finals_first = begin Date.try(:strptime, row[3], '%m/%d/%y') rescue nil end
          schedule.summer_finals_last = begin Date.try(:strptime, row[4], '%m/%d/%y') rescue nil end
          
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