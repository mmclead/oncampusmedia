class RatecardsController < ApplicationController
  before_filter :create_dates_from_strings, only: [:create, :update]
  after_filter :upload_to_dropbox, only: [:create]
  
  def index
    if user_signed_in?
      if params["user"].present?
        @ratecards = current_user.ratecards
      elsif current_user.internal?
        @ratecards = Ratecard.all  
      else
        @ratecards = current_user.ratecards + Ratecard.public_only
      end
    else
      @ratecards = Ratecard.public_only
    end
    
  end
  
  def create
    @ratecard = Ratecard.new(params[:ratecard])
    if user_signed_in?
      @ratecard.user = current_user
    end
    
    if params['schools'].present?
      @ratecard.store_ids = params['schools'].values
      if @ratecard.save
        url = @ratecard
        msg = 'Quote Created Successfully'
      else
        url = schools_url
        msg = 'Quote not created'
      end
    else
      url = schools_url
      msg = 'No Schools Selected'
    end
    redirect_to url, notice: msg
  end
  
  
  
  def show
    @ratecard = Ratecard.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "quote-#{@ratecard.id}",
               template: 'ratecards/show.pdf.haml',
               disposition: 'attachment'
      end
    end
  end
  
  def edit
    @ratecard = Ratecard.find(params[:id])
  end
  
  def update
    @ratecard = Ratecard.find(params[:id])
    if @ratecard.update_attributes(params[:ratecard])
      redirect_to @ratecard, notice: "Quote updated successfully."
    else
      render action: 'edit'
    end
  
  end
  
  def destroy
    if Ratecard.find(params[:id]).delete
      redirect_to ratecards_path, notice: "Quote Deleted"
    else
      redirect_to ratecards_path, notice: "Could not Delete Quote"
    end
    
  end
  
  
  private
  
  def create_dates_from_strings
    if params[:ratecard][:flight_date].present?
      params[:ratecard][:flight_date] = DateTime.strptime(params[:ratecard][:flight_date], '%Y-%m-%d')
    end
    if params[:ratecard][:end_date].present?
      params[:ratecard][:end_date] = DateTime.strptime(params[:ratecard][:end_date], '%Y-%m-%d')
    end
    if params[:ratecard][:quote_date].present?
      params[:ratecard][:quote_date] = DateTime.strptime(params[:ratecard][:quote_date], '%Y-%m-%d')
    end
    if params[:ratecard][:accept_by].present?
      params[:ratecard][:accept_by] = DateTime.strptime(params[:ratecard][:accept_by], '%Y-%m-%d')
    end
  end
  
  def upload_to_dropbox
    if user_signed_in? and current_user.internal?
      client = Dropbox::API::Client.new(:token  => Dropbox_Token, :secret => Dropbox_Secret)
      client.upload "#{@ratecard.user.name}/#{@ratecard.prepared_for}/#{@ratecard.brand}/quote-#{@ratecard.id}.pdf",   
        render_to_string(pdf: "quote.pdf", template: 'ratecards/show.pdf.haml')        
      redirect_to @ratecard, notice: 'Quote created, emailed and uploaded'

    end
  end
  
end
