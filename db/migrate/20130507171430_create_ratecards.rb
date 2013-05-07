class CreateRatecards < ActiveRecord::Migration
  def change
    create_table :ratecards do |t|
      t.string :prepared_for
      t.string :brand
      t.date :quote_date
      t.date :accept_by
      t.integer :spot_length
      t.integer :num_of_weeks
      t.date :flight_date
      t.date :end_date
      t.date :creative_due_date
      t.integer :spot_rate
      t.float :cpm

      t.timestamps
    end
  end
end
