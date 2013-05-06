class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :school
      t.integer :march
      t.integer :april
      t.integer :may
      t.integer :june
      t.integer :july
      t.integer :august
      t.integer :september
      t.integer :october
      t.integer :november
      t.integer :december
      t.integer :january
      t.integer :february

      t.timestamps
    end
    add_index :transactions, :school_id
  end
end
