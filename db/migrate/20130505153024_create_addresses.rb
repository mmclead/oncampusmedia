class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :school
      t.string :street
      t.string :city
      t.string :state

      t.timestamps
    end
    add_index :addresses, :school_id
  end
end
