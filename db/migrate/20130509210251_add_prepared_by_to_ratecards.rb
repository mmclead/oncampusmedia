class AddPreparedByToRatecards < ActiveRecord::Migration
  def change
    add_column :ratecards, :prepared_by, :text
  end
end
