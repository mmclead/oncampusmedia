class ChangeStoreIdToString < ActiveRecord::Migration
  def up
    change_column :schools, :store_id, :string
  end

  def down
    change_column :schools, :store_id, :integer
  end
end
