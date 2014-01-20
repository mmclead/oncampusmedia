class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
      if user.admin?
        can :manage, :all
      elsif user.internal?
        can :manage, Ratecard
        can :manage, School
        can :manage, Ambassador
      elsif user.id.present?
        cannot :read, Ratecard.where('user_id != ?', user.id)
        can :read, Ratecard
        can :create, Ratecard
        can :update, Ratecard, :user_id => user.id
        can :read, School
        can :read, Ambassador
      else
        can :read, Ratecard, user_id: nil
        cannot :read, Ratecard.owned
        can :read, School
        can :create, Ratecard
      end
  end
end
