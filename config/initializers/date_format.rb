Time::DATE_FORMATS.merge!(
  :date => lambda { |time| time.strftime("%m-%d-%Y") }
  
)