class AddAttachmentTransactionsFileToImports < ActiveRecord::Migration
  def self.up
    change_table :imports do |t|
      t.has_attached_file :transactions_file
    end
  end

  def self.down
    drop_attached_file :imports, :transactions_file
  end
end
