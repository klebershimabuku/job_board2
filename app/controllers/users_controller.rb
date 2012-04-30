#encoding: utf-8
class UsersController < ApplicationController
  load_and_authorize_resource except: :welcome
  before_filter :authenticate_user!
  before_filter :find_user, only: [:show, :edit, :destroy]
  before_filter :admin_user, only: :destroy

  def welcome; end

  def index
    @users = User.paginate(page: params[:page])
  end

  def show; end

  def edit; end

  def update
    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      flash[:success] = "Perfil salvo com sucesso!"
      sign_in @user, :bypass => true
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = "#{@user.name} -- foi excluído."
      redirect_to users_path
    end
  end

  protected
  def find_user
    @user = User.find(params[:id])
  end

  def admin_user
    redirect_to root_path unless current_user.role == 'admin' 
  end
end