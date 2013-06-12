class RatecardsController < ApplicationController
  load_and_authorize_resource
  
  before_filter :create_dates_from_strings, only: [:create, :update]
  after_filter :upload_to_dropbox, only: [:create]
  
  autocomplete :ratecard, :prepared_for
  autocomplete :ratecard, :brand
  
  def index
    if user_signed_in?
      if params["user"].present?
        @ratecards = current_user.ratecards
      elsif current_user.internal?
        @ratecards = Ratecard.all
      else
        @ratecards = Ratecard.public_and_mine(current_user.id)
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
        msg = "Proposal Created Successfully"
      else
        url = schools_url
        msg = 'Proposal not created'
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
        render pdf: "proposal-#{@ratecard.brand}-#{@ratecard.quote_date}",
               template: 'ratecards/show.pdf.haml',
               disposition: 'attachment',
               show_as_html: params[:debug]
      end
    end
  end
  
  def edit
    @ratecard = Ratecard.find(params[:id])
    @edit = true
  end

  def update
    @ratecard = Ratecard.find(params[:id])
    if params['remove_schools']
      params[:ratecard][:store_ids] = @ratecard.store_ids - params['remove_schools'].keys
    end
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
    if user_signed_in?
      client = Dropbox::API::Client.new(:token  => Dropbox_Token, :secret => Dropbox_Secret)
      client.upload "#{@ratecard.user.name}/#{@ratecard.prepared_for}/#{@ratecard.brand}/proposal-#{@ratecard.quote_date.strftime('%Y-%m-%d')}.pdf",   
        render_to_string(pdf: "proposal-#{@ratecard.brand}-#{@ratecard.quote_date}", template: 'ratecards/show.pdf.haml')        
      redirect_to @ratecard, notice: "Quote created, emailed and uploaded"

    end
  end
  
end
