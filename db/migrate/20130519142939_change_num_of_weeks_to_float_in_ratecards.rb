class ChangeNumOfWeeksToFloatInRatecards < ActiveRecord::Migration
  def up
    change_column :ratecards, :num_of_weeks, :float
  end

  def down
    change_column :ratecards, :num_of_weeks, :integer
  end
end
