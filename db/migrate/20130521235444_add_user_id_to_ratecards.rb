class AddUserIdToRatecards < ActiveRecord::Migration
  def change
    add_column :ratecards, :user_id, :integer
  end
end
