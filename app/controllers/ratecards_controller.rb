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
    @schools = @ratecard.schools
    @impressions = @ratecard.impressions
    @impressions_per_spot = @ratecard.impressions_per_spot

  end
end
