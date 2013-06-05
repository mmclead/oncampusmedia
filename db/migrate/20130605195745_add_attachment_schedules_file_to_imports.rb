class AddAttachmentSchedulesFileToImports < ActiveRecord::Migration
  def self.up
    change_table :imports do |t|
      t.has_attached_file :schedules_file
    end
  end

  def self.down
    drop_attached_file :imports, :schedules_file
  end
end
