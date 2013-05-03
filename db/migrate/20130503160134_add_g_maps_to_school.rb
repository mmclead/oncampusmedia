class AddGMapsToSchool < ActiveRecord::Migration
  def change
    add_column :schools, :gmaps, :boolean
  end
end
