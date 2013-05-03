class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.integer :store_id
      t.string :school_name
      t.string :address
      t.string :city
      t.string :state
      t.string :monday_hours
      t.string :tuesday_hours
      t.string :wednesday_hours
      t.string :thursday_hours
      t.string :friday_hours
      t.string :saturday_hours
      t.string :sunday_hours
      t.integer :num_of_schools
      t.integer :num_of_schools_included

      t.timestamps
    end
  end
end
