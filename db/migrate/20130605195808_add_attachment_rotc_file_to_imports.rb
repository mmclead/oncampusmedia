class AddAttachmentRotcFileToImports < ActiveRecord::Migration
  def self.up
    change_table :imports do |t|
      t.has_attached_file :rotc_file
    end
  end

  def self.down
    drop_attached_file :imports, :rotc_file
  end
end
