class RatecardsController < ApplicationController
  before_filter :create_dates_from_strings, only: [:create, :update]
  
  def index
    @ratecards = Ratecard.all  
    
  end
  
  def create
    @ratecard = Ratecard.new(params[:ratecard])
    if params['schools'].present?
      @ratecard.store_ids = params['schools'].values
      if @ratecard.save
        redirect_to @ratecard, notice: 'Quote created successfully'
      else
        redirect_to schools_url, notice: 'Quote not created'
      end
    else
      redirect_to schools_url, notice: 'No Schools Selected'
    end
    @params = params
  end
  
  
  
  def show
    @ratecard = Ratecard.find(params[:id])
    @schools = @ratecard.schools
    @impressions = @ratecard.impressions
    @impressions_per_spot = @ratecard.impressions_per_spot
  end
  
  
  private
  
  def create_dates_from_strings
    if params[:ratecard][:flight_date].present?
      params[:ratecard][:flight_date] = DateTime.strptime(params[:ratecard][:flight_date], '%m-%d-%Y')
    end
    if params[:ratecard][:end_date].present?
      params[:ratecard][:end_date] = DateTime.strptime(params[:ratecard][:end_date], '%m-%d-%Y')
    end
    if params[:ratecard][:quote_date].present?
      params[:ratecard][:quote_date] = DateTime.strptime(params[:ratecard][:quote_date], '%m-%d-%Y')
    end
    if params[:ratecard][:accept_by].present?
      params[:ratecard][:accept_by] = DateTime.strptime(params[:ratecard][:accept_by], '%m-%d-%Y')
    end
  end
end
