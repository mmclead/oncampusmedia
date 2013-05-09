class AddPresentedToToRatecards < ActiveRecord::Migration
  def change
    add_column :ratecards, :presented_to, :text
  end
end
