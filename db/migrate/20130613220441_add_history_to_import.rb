class AddHistoryToImport < ActiveRecord::Migration
  def change
    add_column :imports, :imported_schools, :text
    add_column :imports, :imported_transactions, :text
    add_column :imports, :imported_rotc, :text
    add_column :imports, :imported_schedules, :text
    add_column :imports, :imported_summer_schedules, :text
  end
end
