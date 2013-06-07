class Import < ActiveRecord::Base
  attr_accessible :schools_file, :transactions_file, :rotc_file, 
                  :schedules_file, :schedules_file
                  
  has_attached_file :schools_file, storage: :dropbox, 
                    dropbox_credentials: Rails.root.join("config/dropbox.yml"),
                    path: "imports/:id/:filename"
  has_attached_file :transactions_file, storage: :dropbox, 
                    dropbox_credentials: Rails.root.join("config/dropbox.yml"),
                    path: "imports/:id/:filename"
  has_attached_file :rotc_file, storage: :dropbox, 
                    dropbox_credentials: Rails.root.join("config/dropbox.yml"),
                    path: "imports/:id/:filename"
  has_attached_file :schedules_file, storage: :dropbox, 
                    dropbox_credentials: Rails.root.join("config/dropbox.yml"),
                    path: "imports/:id/:filename"
  has_attached_file :schedules_file, storage: :dropbox, 
                    dropbox_credentials: Rails.root.join("config/dropbox.yml"),
                    path: "imports/:id/:filename"
  
  
end
