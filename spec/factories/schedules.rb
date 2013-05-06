# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :schedule do
    school nil
    semester false
    quarter false
    first_classes "2013-05-05"
    spring_finals_first "2013-05-05"
    spring_finals_last "2013-05-05"
    fall_finals_first "2013-05-05"
    fall_finals_last "2013-05-05"
  end
end
