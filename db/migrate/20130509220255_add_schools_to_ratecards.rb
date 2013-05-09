class AddSchoolsToRatecards < ActiveRecord::Migration
  def change
    add_column :ratecards, :store_ids, :text
  end
end
