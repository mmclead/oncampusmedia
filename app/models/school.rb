class School < ActiveRecord::Base
  attr_accessible :address, :city, :num_of_schools, :num_of_schools_included, :school_name, 
                  :state, :zip, :store_id,:sports_attributes, :schedule_attributes, :demographics_attributes, 
                  :hours_attributes, :transactions_attributes, :active, :num_of_screens, :school_type, 
                  :dma, :dma_rank, :starbucks, :coffee_stations, :rotc, :network
  
  acts_as_gmappable :validation => false
  
  has_one :sports, dependent: :destroy
  has_one :schedule, dependent: :destroy
  has_one :demographics, dependent: :destroy
  has_one :hours, dependent: :destroy
  has_one :transactions, dependent: :destroy
  
  default_scope includes(:demographics, :sports, :hours, :transactions, :schedule).order(:dma, :school_name) 
  scope :active, where(active: true)
  scope :inactive, where(active: false)
  scope :deployed, where("num_of_screens > 0")
  scope :not_deployed, where(num_of_screens: 0)
  accepts_nested_attributes_for :sports, :schedule, :demographics, :hours, :transactions
  
  
  def gmaps4rails_address
    "#{address} #{city}, #{state}"
  end
  
  def sorted
    
  end

  def store_info
    {
      hours: hours.hash_for_filter,
      coffee: [starbucks? ? "starbucks" : nil, coffee_stations? ? "coffee_stations": nil ].compact,
      dma: {dma: dma, dma_rank: dma_rank},
      school_type: school_type,
      screen_count: num_of_screens,
      rotc: rotc?
    }
    
  end
  
  def screen_multiplier(weight = Equation.first.screen_weight_multiplier)
    (num_of_screens > 0 ? ((num_of_screens-1) * weight ) : 0)
  end
  
  alias_attribute :name, :school_name
end
