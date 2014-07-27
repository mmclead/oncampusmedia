module RatecardsHelper
  
  def num_of_weeks_in_words(quote)
    s = pluralize(quote.num_of_weeks.to_i, 'week')
    if (quote.num_of_weeks%1*7).to_i > 0
      s+= " and "+ pluralize((quote.num_of_weeks%1*7).to_i, 'day')
    end
    return s
  end
  
  def owned_by(quote)
    quote.user_id.present? ? ( "#{quote.user.name}" rescue 'User') : "Public"
  end
  
  def nearbyLocationsOfSchool(store_ids, school)    
    index = store_ids.index { |store| store["id"] == school.store_id }
    return "#{store_ids[index]['nearbyCount']} #{store_ids[index]['nearbyName']}"
  end
  
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class} 
  end

end
