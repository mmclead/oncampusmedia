class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :phone, :title
  
  has_many :ratecards
  
  
  def internal?
    email.include?("@on-campusmedia.com")
  end
  
  def contact_info
    "#{name}\n#{title}\n#{email}\n#{phone}"
  end
end
