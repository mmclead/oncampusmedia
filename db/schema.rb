# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130606224629) do

  create_table "addresses", :force => true do |t|
    t.integer  "school_id"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "addresses", ["school_id"], :name => "index_addresses_on_school_id"

  create_table "demographics", :force => true do |t|
    t.integer  "school_id"
    t.integer  "average_age"
    t.float    "non_resident_alien"
    t.float    "african_american_black"
    t.float    "two_or_more_races"
    t.float    "asian"
    t.float    "hispanic_latino"
    t.float    "white"
    t.float    "unknown"
    t.float    "american_indian_alaskan_native"
    t.float    "native_hawaiian_pacific_islander"
    t.integer  "enrollment"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "demographics", ["school_id"], :name => "index_demographics_on_school_id"

  create_table "equations", :force => true do |t|
    t.float    "impression_factor"
    t.float    "screen_weight_multiplier"
    t.float    "dwell_time"
    t.float    "spot_length_multiplier"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "hours", :force => true do |t|
    t.integer  "school_id"
    t.time     "monday_open"
    t.time     "monday_close"
    t.time     "tuesday_open"
    t.time     "tuesday_close"
    t.time     "wednesday_open"
    t.time     "wednesday_close"
    t.time     "thursday_open"
    t.time     "thursday_close"
    t.time     "friday_open"
    t.time     "friday_close"
    t.time     "saturday_open"
    t.time     "saturday_close"
    t.time     "sunday_open"
    t.time     "sunday_close"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "hours", ["school_id"], :name => "index_hours_on_school_id"

  create_table "imports", :force => true do |t|
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "schools_file_file_name"
    t.string   "schools_file_content_type"
    t.integer  "schools_file_file_size"
    t.datetime "schools_file_updated_at"
    t.string   "transactions_file_file_name"
    t.string   "transactions_file_content_type"
    t.integer  "transactions_file_file_size"
    t.datetime "transactions_file_updated_at"
    t.string   "schedules_file_file_name"
    t.string   "schedules_file_content_type"
    t.integer  "schedules_file_file_size"
    t.datetime "schedules_file_updated_at"
    t.string   "summer_schedules_file_file_name"
    t.string   "summer_schedules_file_content_type"
    t.integer  "summer_schedules_file_file_size"
    t.datetime "summer_schedules_file_updated_at"
    t.string   "rotc_file_file_name"
    t.string   "rotc_file_content_type"
    t.integer  "rotc_file_file_size"
    t.datetime "rotc_file_updated_at"
  end

  create_table "ratecards", :force => true do |t|
    t.string   "prepared_for"
    t.string   "brand"
    t.date     "quote_date"
    t.date     "accept_by"
    t.integer  "spot_length"
    t.float    "num_of_weeks"
    t.date     "flight_date"
    t.date     "end_date"
    t.date     "creative_due_date"
    t.integer  "spot_rate"
    t.float    "cpm"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.text     "presented_to"
    t.text     "prepared_by"
    t.text     "store_ids"
    t.integer  "user_id"
    t.text     "special_instructions"
    t.float    "additional_cost"
  end

  create_table "schedules", :force => true do |t|
    t.integer  "school_id"
    t.boolean  "semester"
    t.boolean  "quarter"
    t.date     "fall_first_classes"
    t.date     "spring_finals_first"
    t.date     "spring_finals_last"
    t.date     "fall_finals_first"
    t.date     "fall_finals_last"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.date     "summer_first_classes"
    t.date     "summer_finals_first"
    t.date     "summer_finals_last"
    t.date     "spring_first_classes"
  end

  add_index "schedules", ["school_id"], :name => "index_schedules_on_school_id"

  create_table "schools", :force => true do |t|
    t.integer  "store_id"
    t.string   "school_name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "monday_hours"
    t.string   "tuesday_hours"
    t.string   "wednesday_hours"
    t.string   "thursday_hours"
    t.string   "friday_hours"
    t.string   "saturday_hours"
    t.string   "sunday_hours"
    t.integer  "num_of_schools"
    t.integer  "num_of_schools_included"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
    t.string   "dma"
    t.integer  "dma_rank"
    t.string   "school_type"
    t.float    "current_local_annual_traffic"
    t.boolean  "starbucks"
    t.boolean  "coffee_stations"
    t.integer  "num_of_screens"
    t.boolean  "rotc"
    t.string   "store_name"
    t.boolean  "active",                       :default => true
  end

  create_table "sports", :force => true do |t|
    t.integer  "school_id"
    t.boolean  "ncaa_basketball_div_i"
    t.boolean  "ncaa_basketball_div_ii"
    t.boolean  "ncaa_basketball_div_iii"
    t.boolean  "naia_basketball_div_i_and_ii"
    t.boolean  "ncaa_football_div_i"
    t.boolean  "ncaa_football_div_ii"
    t.boolean  "ncaa_football_div_iii"
    t.boolean  "naia_football_div_i_and_ii"
    t.boolean  "ncaa_baseball_div_i"
    t.boolean  "ncaa_baseball_div_ii"
    t.boolean  "ncaa_baseball_div_iii"
    t.boolean  "naia_baseball_div_i_and_ii"
    t.boolean  "ncaa_naia_track_cross_country"
    t.boolean  "njcaa_football_div_i"
    t.boolean  "njcaa_baseball_div_i"
    t.boolean  "njcaa_basketball_div_i"
    t.string   "conference"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "sports", ["school_id"], :name => "index_sports_on_school_id"

  create_table "transactions", :force => true do |t|
    t.integer  "school_id"
    t.integer  "march"
    t.integer  "april"
    t.integer  "may"
    t.integer  "june"
    t.integer  "july"
    t.integer  "august"
    t.integer  "september"
    t.integer  "october"
    t.integer  "november"
    t.integer  "december"
    t.integer  "january"
    t.integer  "february"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "total"
  end

  add_index "transactions", ["school_id"], :name => "index_transactions_on_school_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "phone"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "admin"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
