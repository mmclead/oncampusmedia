class RatecardsController < ApplicationController
  
  def create
    @ratecard = Ratecard.new
    @schools = params['schools'].values.map {|store_id| School.where(store_id: store_id).first}
    @impressions = @ratecard.calculate_impressions(@schools)
    @impressions_per_spot = @ratecard.impressions_per_spot(@impressions, @schools)
    @params = params
  end
end
