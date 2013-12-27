class AddAmbassadorIdToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :ambassador_id, :id
  end
end
