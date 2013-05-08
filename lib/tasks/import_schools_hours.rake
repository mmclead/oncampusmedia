require "csv"
namespace :importer do
  task :hours => :environment do
    if ENV["SCHOOLS_FILE"].blank?
      puts "Schools file cannot be blank.  Pass SCHOOLS_FILE=<filename> to this method."
    else
      SCHOOLS_FILE = File.new(ENV["SCHOOLS_FILE"]).read.gsub("\r\r","\r")
      index = 0
      CSV.parse(SCHOOLS_FILE, {headers: true}) do |row|
        store_id = row[0]
        school = School.where(store_id: store_id).first
        
        if school.present?
          hours = Hours.new
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