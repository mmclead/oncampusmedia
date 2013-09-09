class AddNetworkToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :network, :string
  end
end
