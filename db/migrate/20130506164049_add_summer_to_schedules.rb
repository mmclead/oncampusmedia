class AddSummerToSchedules < ActiveRecord::Migration
  def change
    change_table :schedules do |t|
      t.date :summer_first_classes
      t.date :summer_finals_first
      t.date :summer_finals_last
      t.date :spring_first_classes
    end
  end
end
