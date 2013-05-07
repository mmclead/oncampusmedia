class SchoolsController < ApplicationController
  
  def index
    @schools = School.all
    @json = @schools.to_gmaps4rails do |school, marker|
      marker.infowindow render_to_string(partial: "/schools/infowindow", locals: {school: school})
      marker.title "#{school.school_name}"
      json = {sports: school.sports.active_in, conference: school.sports.conference, 
              state: school.state, demographics: school.demographics.percentages}
      marker.json(json)   
    end
  end
  
  def search
    
  end
  
  def results
    
  end
  
end
