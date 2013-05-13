class Sports < ActiveRecord::Base
  belongs_to :school
  attr_accessible :conference, :naia_baseball_div_i_and_ii, :naia_basketball_div_i_and_ii, :naia_football_div_i_and_ii, :ncaa_baseball_div_i, :ncaa_baseball_div_ii, :ncaa_baseball_div_iii, :ncaa_basketball_div_i, :ncaa_basketball_div_ii, :ncaa_basketball_div_iii, :ncaa_football_div_i, :ncaa_football_div_ii, :ncaa_football_div_iii, :ncaa_naia_track_cross_country, :njcaa_baseball_div_i, :njcaa_basketball_div_i, :njcaa_football_div_i, 
  :CONFERENCE, :NAIA_BASEBALL_Div_I_and_II, :NAIA_BASKETBALL_Div_I_and_II, :NAIA_FOOTBALL_Div_I_and_II, :NCAA_BASEBALL_Div_I, :NCAA_BASEBALL_Div_II, :NCAA_BASEBALL_Div_III, :NCAA_BASKETBALL_Div_I, :NCAA_BASKETBALL_Div_II, :NCAA_BASKETBALL_Div_III, :NCAA_FOOTBALL_Div_I, :NCAA_FOOTBALL_Div_II, :NCAA_FOOTBALL_Div_III, :NCAA_NAIA_Track_Cross_Country, :NJCAA_BASEBALL_Div_I, :NJCAA_BASKETBALL_Div_I, :NJCAA_FOOTBALL_Div_I
  
  
  def active_in
    SPORT_LIST.select { |s| self.send(s) }
  end
end
