require "csv"
namespace :importer do
  task :rotc => :environment do
    if ENV["ROTC_FILE"].blank?
      puts "Schedules file cannot be blank.  Pass ROTC_FILE=<filename> to this method."
    else
      ROTC_FILE = IO.read(ENV["ROTC_FILE"]).force_encoding("ISO-8859-1").encode("utf-8", replace: nil).gsub("\r\r","\r")
      index = 0
      CSV.parse(ROTC_FILE, {headers: true}) do |row|
        store_id = row[0]
        school = School.where(store_id: store_id).first
        
        if school.present?
          school.store_name = row[1]
          school.rotc = row[3].present?
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