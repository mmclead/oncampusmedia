require "csv"
namespace :importer do
  task :schools => :environment do
    SCHOOLS_FILE = ENV["SCHOOLS_FILE"]
    if SCHOOLS_FILE.blank?
      puts "Schools file cannot be blank.  Pass SCHOOLS_FILE=<filename> to this method."
    else
      index = 0
      CSV.foreach(SCHOOLS_FILE) do |row|
        store_id = row[0]
        school_name = row[1]
        address = row[2]
        city = row[3]
        state = row[4]
        sunday_hours = row[5]
        monday_hours = row[6]
        tuesday_hours = row[7]
        wednesday_hours = row[8]
        thursday_hours = row[9]
        friday_hours = row[10]
        saturday_hours = row[11]
        num_of_schools = row[12]
        num_of_schools_included = row[13]
        
        unless school_name.blank? or address=="Address"
          school = School.new
          school.store_id = store_id
          school.school_name = school_name
          school.address = address
          school.city = city
          school.state = state
          school.sunday_hours = sunday_hours
          school.monday_hours = monday_hours
          school.tuesday_hours = tuesday_hours
          school.wednesday_hours = wednesday_hours
          school.thursday_hours = thursday_hours
          school.friday_hours = friday_hours
          school.saturday_hours = saturday_hours
          school.num_of_schools = num_of_schools
          school.num_of_schools_included = num_of_schools_included
          puts 'saving ' + school_name.to_s
          school.save!
        else
          puts 'bad data at row' + index.to_s
        end
        index+=1
      end
    end
  end
end
