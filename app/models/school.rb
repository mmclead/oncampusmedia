class School < ActiveRecord::Base
  attr_accessible :address, :city, :num_of_schools, :num_of_schools_included, :school_name, :state, :store_id,:sports_attributes, :schedule_attributes, :demographics_attributes, :hours_attributes, :transactions_attributes
  
  acts_as_gmappable :validation => false
  
  has_one :sports
  has_one :schedule
  has_one :demographics
  has_one :hours
  has_one :transactions
  
  default_scope order(:school_name)
  accepts_nested_attributes_for :sports, :schedule, :demographics, :hours, :transactions
  
  
  def gmaps4rails_address
    "#{address} #{city}, #{state}"
  end
  

  def store_info
    {
      hours: hours.hash_for_filter,
      coffee: [starbucks? ? "starbucks" : nil, coffee_stations? ? "coffee_stations": nil ].compact,
      dma: {dma: dma, dma_rank: dma_rank},
      school_type: school_type
    }
    
  end
  
  alias_attribute :name, :school_name
end
