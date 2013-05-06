# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :hour, :class => 'Hours' do
    school nil
    monday_open "2013-05-05 09:09:29"
    monday_close "2013-05-05 09:09:29"
    tuesday_open "2013-05-05 09:09:29"
    tuesday_close "2013-05-05 09:09:29"
    wednesday_open "2013-05-05 09:09:29"
    wednesday_close "2013-05-05 09:09:29"
    thursday_open "2013-05-05 09:09:29"
    thursday_close "2013-05-05 09:09:29"
    friday_open "2013-05-05 09:09:29"
    friday_close "2013-05-05 09:09:29"
    saturday_open "2013-05-05 09:09:29"
    saturday_close "2013-05-05 09:09:29"
    sunday_open "2013-05-05 09:09:29"
    sunday_close "2013-05-05 09:09:29"
  end
end
