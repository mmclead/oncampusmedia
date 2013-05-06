class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.references :school
      t.boolean :semester
      t.boolean :quarter
      t.date :first_classes
      t.date :spring_finals_first
      t.date :spring_finals_last
      t.date :fall_finals_first
      t.date :fall_finals_last

      t.timestamps
    end
    add_index :schedules, :school_id
  end
end
