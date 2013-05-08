require "csv"
namespace :importer do
  task :transactions => :environment do
    if ENV["TRANSACTIONS_FILE"].blank?
      puts "Schedules file cannot be blank.  Pass TRANSACTIONS_FILE=<filename> to this method."
    else
      TRANSACTIONS_FILE = File.new(ENV["TRANSACTIONS_FILE"]).read.gsub("\r\r","\r")
      index = 0
      CSV.parse(TRANSACTIONS_FILE, {headers: true}) do |row|
        store_id = row[0]
        school = School.where(store_id: store_id).first
        
        if school.present?
          transaction = Transactions.new
          transaction.march = row[2].to_i
          transaction.april = row[3].to_i
          transaction.may = row[4].to_i
          transaction.june = row[5].to_i
          transaction.july = row[6].to_i
          transaction.august = row[7].to_i
          transaction.september = row[8].to_i
          transaction.october = row[9].to_i
          transaction.november = row[10].to_i
          transaction.december = row[11].to_i
          transaction.january = row[12].to_i
          transaction.february = row[13].to_i
          school.transactions = transaction
          
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