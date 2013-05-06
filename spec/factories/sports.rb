# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sport, :class => 'Sports' do
    school nil
    NCAA_BASKETBALL_Div_I false
    NCAA_BASKETBALL_Div_II false
    NCAA_BASKETBALL_Div_III false
    NAIA_BASKETBALL_Div_I_and_II false
    NCAA_FOOTBALL_Div_I false
    NCAA_FOOTBALL_Div_II false
    NCAA_FOOTBALL_Div_III false
    NAIA_FOOTBALL_Div_I_and_II false
    NCAA_BASEBALL_Div_I false
    NCAA_BASEBALL_Div_II false
    NCAA_BASEBALL_Div_III false
    NAIA_BASEBALL_Div_I_and_II false
    NCAA_NAIA_Track_Cross_Country false
    NJCAA_FOOTBALL_Div_I false
    NJCAA_BASEBALL_Div_I false
    NJCAA_BASKETBALL_Div_I false
    CONFERENCE false
  end
end
