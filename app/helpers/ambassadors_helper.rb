module AmbassadorsHelper


  def list_schools(schools)
    raw schools.map {|s| link_to s.name, [:edit, s]}.join(", ")
  end


end
