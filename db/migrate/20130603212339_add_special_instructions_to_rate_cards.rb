class AddSpecialInstructionsToRateCards < ActiveRecord::Migration
  def change
    add_column :ratecards, :special_instructions, :text
  end
end
