class SchoolsController < ApplicationController
  
  def index
    @schools = School.all
    @json = @schools.to_gmaps4rails do |school, marker|
      marker.infowindow render_to_string(partial: "/schools/infowindow", locals: {school: school})
      marker.title "#{school.school_name}"
      marker.json({num_of_schools: school.num_of_schools})   
    end
  end
end
