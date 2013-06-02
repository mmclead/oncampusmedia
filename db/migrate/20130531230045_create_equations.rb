class CreateEquations < ActiveRecord::Migration
  def change
    create_table :equations do |t|
      t.float :impression_factor
      t.float :screen_weight_multiplier
      t.float :dwell_time
      t.float :spot_length_multiplier

      t.timestamps
    end
  end
end
