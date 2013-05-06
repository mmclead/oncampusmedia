# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :demographic, :class => 'Demographics' do
    school nil
    average_age 1
    non_resident_alien 1.5
    african_american_black 1.5
    two_or_more_races 1.5
    asian 1.5
    hispanic_latino 1.5
    white 1.5
    unknown 1.5
    american_indian_alaskan_native 1.5
    native_hawaiian_pacific_islander 1.5
    enrollment 1
  end
end
