class School < ActiveRecord::Base
  attr_accessible :address, :city, :num_of_schools, :num_of_schools_included, :school_name, 
                  :state, :zip, :store_id,:sports_attributes, :schedule_attributes, :demographics_attributes, 
                  :hours_attributes, :transactions_attributes, :active, :num_of_screens, :school_type, 
                  :dma, :dma_rank, :starbucks, :coffee_stations, :rotc, :network, :ambassador_ids, :ambassadors_attributes
  
  acts_as_gmappable :validation => false
  
  has_one :sports, dependent: :destroy
  has_one :schedule, dependent: :destroy
  has_one :demographics, dependent: :destroy
  has_one :hours, dependent: :destroy
  has_one :transactions, dependent: :destroy

  has_and_belongs_to_many :ambassadors

  scope :with_extras, includes(:demographics, :sports, :hours, :transactions, :schedule).order(:dma, :school_name)
  scope :active, where(active: true)
  scope :inactive, where(active: false)
  scope :deployed, where("num_of_screens > 0")
  scope :not_deployed, where(num_of_screens: 0)
  accepts_nested_attributes_for :sports, :schedule, :demographics, :hours, :transactions, :ambassadors
  
  validate :store_id_unique_within_network
  

  def store_id_unique_within_network
    if School.where(store_id: store_id, network: network).count > 1
      errors.add(:store_id, "must be unique within network")
    end
  end

  def gmaps4rails_address
    "#{address} #{city}, #{state}"
  end
  
  def sorted
    
  end

  def store_info
    {
      zip: zip,
      hours: hours.hash_for_filter,
      coffee: [starbucks? ? "starbucks" : nil, coffee_stations? ? "coffee_stations": nil ].compact,
      dma: {dma: dma, dma_rank: dma_rank},
      school_type: school_type,
      screen_count: num_of_screens,
      rotc: rotc?
    }
    
  end
  
  def ambassadors_list
    ambassadors.collect{|a| "#{a.name}_#{a.id}"}
  end

  def has_screens?
    num_of_screens.to_i > 0 ? 1 : 0
  end

  def screen_multiplier(weight = Equation.first.screen_weight_multiplier)
    (num_of_screens.to_i > 0 ? ((num_of_screens.to_i-1) * weight ) : 0)
  end
  
  alias_attribute :name, :school_name
end
