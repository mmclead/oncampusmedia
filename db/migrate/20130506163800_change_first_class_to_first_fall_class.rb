class ChangeFirstClassToFirstFallClass < ActiveRecord::Migration
  def up
    rename_column :schedules, :first_classes, :fall_first_classes
  end

  def down
    rename_column :schedules, :fall_first_classes, :first_classes
  end
end
