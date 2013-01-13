# encoding: utf-8
class PostsController < ApplicationController
  load_and_authorize_resource except: [:index, :show, :new, :create, :feeds]
  before_filter :authenticate_user!, except: [:index, :show, :tags, :feeds]
  before_filter :find_post, only: [:show, :edit, :update, :suspend, :suspend_alert]
  before_filter :check_for_contact_information, only: 'new'

  def index
    @posts = Post.published
  end

  def new
    @post = Post.new
  end

  def show
    render :file => "#{Rails.root}/public/404.html", :status => :not_found if @post.status == 'expired'
  end

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

  def feeds
    @posts = Post.published
    
    respond_to do |format|
      format.rss { render layout: false }
      format.atom { redirect_to posts_feeds_path(:format => :rss), :status => :moved_permanently }
    end
  end

  protected
  def find_post
    @post = Post.find(params[:id])
  end

  def check_for_contact_information
    if current_user.role == 'publisher' && current_user.contact_info.nil?
      flash[:error] = "Informações para contato não encontradas."
      redirect_to user_path(current_user)
    elsif current_user.role == 'publisher'&& current_user.contact_info.present?
      return
    else
      flash[:error] = "Acesso Negado"
      redirect_to root_path
    end
  end

end