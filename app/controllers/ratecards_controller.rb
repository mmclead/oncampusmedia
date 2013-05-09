class RatecardsController < ApplicationController
  
  def create
    @ratecard = Ratecard.new(params[:ratecard])
    @ratecard.store_ids = params['schools'].values
    @schools = params['schools'].values.map {|store_id| School.where(store_id: store_id).first}
    @impressions = @ratecard.calculate_impressions(@schools)
    @impressions_per_spot = @ratecard.impressions_per_spot(@impressions, @schools)
    @params = params
  end
  
  
  
  def show
    @ratecard = Ratecard.find(params[:id])
    
    
  end
end
