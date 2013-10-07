class AddDiscountAmountToRateCard < ActiveRecord::Migration
  def change
    add_column :ratecards, :discount, :float
  end
end
