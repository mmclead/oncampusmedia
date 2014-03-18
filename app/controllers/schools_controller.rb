class SchoolsController < ApplicationController
  load_and_authorize_resource, except = [:create, :update]
  
  def new
    @school = School.new
    @school.schedule = Schedule.new
    @school.hours = Hours.new
    @school.sports = Sports.new
    @school.demographics = Demographics.new
    @school.transactions = Transactions.new
  end
  
  def create

    if params[:ambassador_id]
      params.delete("ambassador")
    end

    if params[:new_ambassador]
      params.delete("ambassador_id")
    end

    @school = School.new(params[:school])
    if @school.save
      redirect_to schools_url, notice: "School Created"
    else
      render 'new'
    end
  end
  
  def index
    if params[:inactive]
      @schools = School.inactive.with_extras
    elsif params[:include_not_deployed]
      @schools = School.active.with_extras
    elsif params[:not_deployed_only]
      @schools = School.active.not_deployed.with_extras
    else
      @schools = School.active.deployed.with_extras
    end
    @json = @schools.to_gmaps4rails do |school, marker|
      #marker.infowindow render_to_string(partial: "/schools/infowindow", locals: {school: school})
      marker.title "#{school.school_name}" 
      json = {id: school.id, store_id: school.store_id, network: school.network, ambassadors: school.ambassadors_list,
              sports: school.sports.active_in, conference: school.sports.conference, 
              state: school.state, demographics: school.demographics.hash_for_filter, store_info: school.store_info, 
              transactions: school.transactions.hash_for_filter, schedule: school.schedule.hash_for_filter}
      marker.json(json)   
    end
  end
  
  def edit
    @school = School.find(params[:id])
    @my_ambassadors = @school.ambassadors
    puts "my_ambassadors are: #{@my_ambassadors}"
    @not_my_ambassadors = Ambassador.all - @my_ambassadors
    #@school.ambassadors.build
  end
  
  def update
    @school = School.find(params[:id])
    params[:school][:ambassador_ids].compact!

    if @school.update_attributes(params[:school])
      redirect_to edit_school_url, id: @school.id, notice: "#{@school.name} updated successfully."
    else
      render action: 'edit'
    end
  end
  
  def destroy
    if @school.destroy
      redirect_to schools_url
    else
      redirect_to edit_school_path(@school)
    end
  end
  
end
