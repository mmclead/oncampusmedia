module RatecardsHelper
  
  def num_of_weeks_in_words(quote)
    s = pluralize(quote.num_of_weeks.to_i, 'week')
    if (quote.num_of_weeks%1*7).to_i > 0
      s+= "and "+ pluralize((quote.num_of_weeks%1*7).to_i, 'day')
    end
    return s
  end
  
  def owned_by(quote)
    quote.user_id.present? ? "#{quote.user.name}" : "Public"
  end
  
  
end
