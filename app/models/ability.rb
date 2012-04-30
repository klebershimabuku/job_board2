class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    can [:welcome, :read, :create, :new], User

    if user.role == 'admin'
      can :manage, :all
    end

    if user.role == 'member'
      can :manage, User, :id => user.id
      cannot :index, User
    end
  end
end
