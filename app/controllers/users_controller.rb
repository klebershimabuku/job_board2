class UsersController < ApplicationController

  def welcome; end

  def show
    @user = User.find(params[:id])
  end

end
