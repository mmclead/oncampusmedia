# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ratecard do
    prepared_for "MyString"
    brand "MyString"
    quote_date "2013-05-07"
    accept_by "2013-05-07"
    spot_length 1
    num_of_weeks 1
    flight_date "2013-05-07"
    end_date "2013-05-07"
    creative_due_date "2013-05-07"
    spot_rate 1
    cpm 1.5
  end
end
