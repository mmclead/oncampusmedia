class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
      if user.internal?
        can :manage, :all
      elsif user.id.present?
        puts "ID Present"
        cannot :read, Ratecard.where('user_id != ?', user.id)
        can :read, Ratecard
        can :create, Ratecard
        can :update, Ratecard, :user_id => user.id
        can :read, School
      else
        puts "Not logged in"
        can :read, Ratecard, user_id: nil
        cannot :read, Ratecard.owned
        can :read, School
        can :create, Ratecard

      end
      
    
    
  end
end
