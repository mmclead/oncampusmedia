class CreateDemographics < ActiveRecord::Migration
  def change
    create_table :demographics do |t|
      t.references :school
      t.integer :average_age
      t.float :non_resident_alien
      t.float :african_american_black
      t.float :two_or_more_races
      t.float :asian
      t.float :hispanic_latino
      t.float :white
      t.float :unknown
      t.float :american_indian_alaskan_native
      t.float :native_hawaiian_pacific_islander
      t.integer :enrollment

      t.timestamps
    end
    add_index :demographics, :school_id
  end
end
