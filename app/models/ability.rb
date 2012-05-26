class Ability
  include CanCan::Ability

  def initialize(user)
    
    user ||= User.new # guest user (not logged in)

    if user.role == 'admin'
      can :manage, :all
    elsif user.role == 'member'
      can :read, User
      can :manage, [User,Post] , :id => user.id
      cannot :index, User # list users page
    else
      can :read, :all
    end
  end
end
