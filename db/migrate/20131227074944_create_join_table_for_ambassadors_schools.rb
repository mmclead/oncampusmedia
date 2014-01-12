class CreateJoinTableForAmbassadorsSchools < ActiveRecord::Migration
  def change
    create_table :ambassadors_schools, id: false do |t|
      t.references :ambassador, :school
    end

    add_index :ambassadors_schools, [:ambassador_id, :school_id], unique: true
  end
end
