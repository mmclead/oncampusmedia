class RatecardsController < ApplicationController
  load_and_authorize_resource
  
  helper_method :sort_column, :sort_direction
  
  before_filter :create_dates_from_strings, only: [:create, :update]

  after_filter :start_upload, only: [:create, :update]
  
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
    if user_signed_in?
      @ratecard.user = current_user
    end
    
    if params['schools'].present?
      puts params['schools']
      @ratecard.store_ids = params['schools'].values.collect { |val| val.gsub(/[{}:]/,'').split(', ').map{|h| h1,h2 = h.split('=>'); {h1 => h2}}.reduce(:merge)
 } 
      if @ratecard.save
        url = @ratecard
        msg = "Proposal created successully"
      else
        url = schools_url
        msg = "Proposal not Created"
      end
    else
      url = schools_url
      msg = "No Schools Selected"
    end
    redirect_to url, notice: msg
  end
  
  def show
    if params[:sortCol] && params[:sortDir]
      column_array = ["store_id", "name", "school_type", "address", "city", "state", "dma", "dma_rank", "num_of_screens"]
      sort_column = column_array[params[:sortCol].to_i].present? ? column_array[params[:sortCol].to_i] : nil
      sort_direction = params[:sortDir]
      @schools = @ratecard.schools(sort_column, sort_direction, true)
    else
      @schools = @ratecard.schools()
    end
    respond_to do |format|
      format.html
      if params[:contract].present?
        format.pdf do
          RatecardsController.delay.upload_contract_to_dropbox(@ratecard) unless params[:debug]
          render pdf: "contract-#{@ratecard.prepared_for}-#{Time.now.to_formatted_s(:date)}",
                 template: 'ratecards/contract.pdf.haml',
                 disposition: 'attachment',
                 show_as_html: params[:debug]
        end
      else
        format.pdf do
          
          render pdf: "proposal-#{@ratecard.brand.strip}-#{@ratecard.quote_date}",
                 template: 'ratecards/show.pdf.haml',
                 disposition: 'attachment',
                 show_as_html: params[:debug]
        end
      end
    end
  end
  
  def edit
    @schools = @ratecard.schools(sort_column, sort_direction)
    @edit = true
  end

  def update
    if params['remove_schools']
      params[:ratecard][:store_ids] = @ratecard.store_ids.delete_if { |x| params['remove_schools'].keys.include?(x["id"]) }
      puts "In it", params
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
  
  
  def sort_column
    School.column_names.include?(params[:sort]) ? params[:sort] : "dma"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
  
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

  def start_upload
    RatecardsController.delay.upload_to_dropbox(@ratecard)
  end
  
  def self.upload_contract_to_dropbox(ratecard)
    @ratecard = ratecard
    ac = ApplicationController.new
    ac.instance_variable_set(:@ratecard, ratecard)
    ac.instance_variable_set(:@user, ratecard.user)
    ac.instance_variable_set(:@sortCol, 6)
    ac.instance_variable_set(:@sortDir, 'desc')
    ac.instance_variable_set(:@schools, @ratecard.schools)
    client = Dropbox::API::Client.new(:token  => Dropbox_Token, :secret => Dropbox_Secret)
    client.upload "#{@ratecard.user.name.strip}/#{@ratecard.prepared_for.strip}/#{@ratecard.brand.strip}/contract-#{Time.now.strftime('%Y-%m-%d')}.pdf",   
      ac.render_to_string(pdf: "contract-#{@ratecard.brand.strip}-#{Time.now.strftime('%Y-%m-%d')}", template: 'ratecards/contract.pdf.haml')        
  end
  
  def self.upload_to_dropbox(ratecard)
    @ratecard = ratecard
    ac = ApplicationController.new
    ac.instance_variable_set(:@ratecard, ratecard)
    ac.instance_variable_set(:@user, ratecard.user)
    ac.instance_variable_set(:@sortCol, 6)
    ac.instance_variable_set(:@sortDir, 'desc')
    ac.instance_variable_set(:@schools, @ratecard.schools)
    client = Dropbox::API::Client.new(:token  => Dropbox_Token, :secret => Dropbox_Secret)
    client.upload "#{@ratecard.user.name.strip}/#{@ratecard.prepared_for.strip}/#{@ratecard.brand.strip}/proposal-#{@ratecard.quote_date.strftime('%Y-%m-%d')}.pdf",   
      ac.render_to_string(pdf: "proposal-#{@ratecard.brand.strip}-#{@ratecard.quote_date}", template: 'ratecards/show.pdf.haml')        
  end
  
end
