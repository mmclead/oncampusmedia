class RatecardsController < ApplicationController
  
  
  def index
    @ratecards = Ratecard.all  
    
  end
  
  def create
    @ratecard = Ratecard.new(params[:ratecard])
    @ratecard.store_ids = params['schools'].values
    if @ratecard.save
      redirect_to @ratecard, notice: 'Quote created successfully'
    else
      render schools_url
    end
    @params = params
  end
  
  
  
  def show
    @ratecard = Ratecard.find(params[:id])
    @schools = @ratecard.store_ids.map {|store_id| School.where(store_id: store_id).first}
    @impressions = @ratecard.calculate_impressions(@schools)
    @impressions_per_spot = @ratecard.impressions_per_spot(@impressions, @schools)

  end
end
