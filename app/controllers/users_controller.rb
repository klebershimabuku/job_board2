#encoding: utf-8
class UsersController < ApplicationController
  load_and_authorize_resource except: :welcome
  before_filter :authenticate_user!
  before_filter :find_user, only: [:show, :edit, :update, :destroy]

  def welcome 
    redirect_to root_path if current_user && current_user.sign_in_count > 1
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @posts = Post.where('user_id = ?', current_user)
  end

  def edit; end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Perfil salvo com sucesso!"
      sign_in @user, :bypass => true unless current_user.role == 'admin'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    if current_user.role == 'member' 
      flash[:success] = "Seu cadastro foi removido."
      redirect_to root_path
    elsif current_user.role == 'admin'
      flash[:success] = "#{@user.name} -- foi excluído."
      redirect_to users_path
    end
  end

  protected
  def find_user
    @user = User.find(params[:id])
  end

end