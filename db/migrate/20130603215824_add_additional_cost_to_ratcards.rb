class AddAdditionalCostToRatcards < ActiveRecord::Migration
  def change
    add_column :ratecards, :additional_cost, :float
  end
end
