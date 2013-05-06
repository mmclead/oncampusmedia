class Sports < ActiveRecord::Base
  belongs_to :school
  attr_accessible :CONFERENCE, :NAIA_BASEBALL_Div_I_and_II, :NAIA_BASKETBALL_Div_I_and_II, :NAIA_FOOTBALL_Div_I_and_II, :NCAA_BASEBALL_Div_I, :NCAA_BASEBALL_Div_II, :NCAA_BASEBALL_Div_III, :NCAA_BASKETBALL_Div_I, :NCAA_BASKETBALL_Div_II, :NCAA_BASKETBALL_Div_III, :NCAA_FOOTBALL_Div_I, :NCAA_FOOTBALL_Div_II, :NCAA_FOOTBALL_Div_III, :NCAA_NAIA_Track_Cross_Country, :NJCAA_BASEBALL_Div_I, :NJCAA_BASKETBALL_Div_I, :NJCAA_FOOTBALL_Div_I
  
  
  def active_in
    SPORT_LIST.select { |s| self.send(s) }
  end
end
