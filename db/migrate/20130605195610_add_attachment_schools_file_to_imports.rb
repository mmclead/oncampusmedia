class AddAttachmentSchoolsFileToImports < ActiveRecord::Migration
  def self.up
    change_table :imports do |t|
      t.has_attached_file :schools_file
    end
  end

  def self.down
    drop_attached_file :imports, :schools_file
  end
end
