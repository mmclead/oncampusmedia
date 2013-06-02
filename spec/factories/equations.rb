# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :equation do
    impression_factor 1.5
    screen_weight_multiplier 1.5
    dwell_time 1.5
    spot_length_multiplier 1.5
  end
end
