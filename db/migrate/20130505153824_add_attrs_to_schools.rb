class AddAttrsToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :dma, :string
    add_column :schools, :dma_rank, :integer
    add_column :schools, :school_type, :string
    add_column :schools, :current_local_annual_traffic, :float
    add_column :schools, :starbucks, :boolean
    add_column :schools, :coffee_stations, :boolean
    add_column :schools, :num_of_screens, :integer
  end
end
