# encoding: utf-8
class PostsController < ApplicationController
  load_and_authorize_resource except: [:index, :show, :new, :create]
  before_filter :authenticate_user!, except: [:index, :show, :tags]
  before_filter :find_post, only: [:show, :edit, :update, :suspend, :suspend_alert]
  before_filter :check_for_contact_information, only: 'new'

  def index
    @posts = Post.published
  end

  def new
    @post = Post.new
  end

  def show;  end

  def create
    @post = current_user.posts.build(params[:post])
    if @post.save
      redirect_to successful_submitted_posts_path
    else
      render 'new'
    end
  end

  def edit;  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      flash[:success] = 'Anúncio modificado com sucesso.'
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def tags
    @posts = Post.published_filter_by_tag(params[:tags])
  end

  def successful_submitted; end

  def suspend_alert; end

  def suspend
    if @post.suspend!
      redirect_to post_path(@post), alert: 'Anúncio suspenso com sucesso.' 
    end
  end

  protected
  def find_post
    @post = Post.find(params[:id])
  end

  def check_for_contact_information
    if current_user.contact_info.nil?
      flash[:error] = "Informações para contato não encontradas."
      redirect_to user_path(current_user)
    end
  end
end