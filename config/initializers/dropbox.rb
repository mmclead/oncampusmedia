Dropbox::API::Config.app_key    = ENV['DB_APP_KEY']
Dropbox::API::Config.app_secret = ENV['DB_APP_SECRET']
Dropbox::API::Config.mode       = "sandbox"

Dropbox_Token = ENV['DB_CLIENT_TOKEN'] 
Dropbox_Secret = ENV['DB_CLIENT_SECRET'] 
