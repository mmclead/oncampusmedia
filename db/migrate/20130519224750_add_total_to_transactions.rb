class AddTotalToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :total, :integer
  end
end
