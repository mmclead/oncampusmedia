class AddAttachmentSummerSchedulesFileToImports < ActiveRecord::Migration
  def self.up
    change_table :imports do |t|
      t.has_attached_file :summer_schedules_file
    end
  end

  def self.down
    drop_attached_file :imports, :summer_schedules_file
  end
end
