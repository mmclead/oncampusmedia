class AddToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :rotc, :boolean
    add_column :schools, :store_name, :string
  end
end
