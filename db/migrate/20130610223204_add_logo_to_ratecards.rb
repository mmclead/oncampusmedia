class AddLogoToRatecards < ActiveRecord::Migration
  def up
    add_attachment :ratecards, :logo
  end
  
  def down
    remove_attachement :ratecards, :logo
  end
  
end
