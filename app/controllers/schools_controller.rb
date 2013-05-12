class SchoolsController < ApplicationController
  
  
  def new
    @school = School.new
    @school.schedule = Schedule.new
    @school.hours = Hours.new
    @school.sports = Sports.new
    @school.demographics = Demographics.new
    @school.transactions = Transactions.new
  end
  
  def create
    
  end
  def index
    @schools = School.all
    @json = @schools.to_gmaps4rails do |school, marker|
      marker.infowindow render_to_string(partial: "/schools/infowindow", locals: {school: school})
      marker.title "#{school.school_name}" 
      json = {store_id: school.store_id, sports: school.sports.active_in, conference: school.sports.conference, 
              state: school.state, demographics: school.demographics.percentages}
      marker.json(json)   
    end
  end
  
  def edit
    @school = School.find(params[:id])
  end
  
  def update
    
  end
  
end
