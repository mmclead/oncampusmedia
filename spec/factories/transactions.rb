# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction, :class => 'Transactions' do
    school nil
    march 1
    april 1
    may 1
    june 1
    july 1
    august 1
    september 1
    october 1
    november 1
    december 1
    january 1
    february 1
  end
end
