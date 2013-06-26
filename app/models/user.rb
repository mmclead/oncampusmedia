class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :phone, :title
  validates_presence_of :name, :phone, :title
  validates :email, :presence => true, :email => true
  
  has_many :ratecards
  
  
  def internal?
    email.include?("@on-campusmedia.com")
  end
  
  def barnes?
    email.include?("@bncollege.com")
  end
  
  def contact_info
    "#{name}\n#{title}\n#{email}\n#{phone}"
  end
end
