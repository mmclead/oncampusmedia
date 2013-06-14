class AddBooleansToImport < ActiveRecord::Migration
  def change
    add_column :imports, :schools_import_has_run, :boolean
    add_column :imports, :transactions_import_has_run, :boolean
    add_column :imports, :rotc_import_has_run, :boolean
    add_column :imports, :schedules_import_has_run, :boolean
    add_column :imports, :summer_schedules_import_has_run, :boolean
  end
end
