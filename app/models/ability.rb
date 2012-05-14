class Ability
  include CanCan::Ability

  def initialize(user)
    
    user ||= User.new # guest user (not logged in)

    if user.role == 'admin'
      can :manage, :all
    end

    if user.role == 'member'
      can :manage, User, :id => user.id
      cannot :index, User
    end

    can [:welcome, :read, :create, :new], User

  end
end
