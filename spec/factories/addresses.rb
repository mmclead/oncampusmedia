# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    school nil
    street "MyString"
    city "MyString"
    state "MyString"
  end
end
