# encoding: utf-8
class PostsController < ApplicationController
  load_and_authorize_resource :only => [:new, :create]
  before_filter :authenticate_user!, except: [:index, :show, :tags]
  respond_to :html

  def index
    @posts = Post.approved
  end

  def new
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = current_user.posts.build(params[:post])
    if @post.save
      redirect_to successful_submitted_posts_path
    else
      render 'new'
    end
  end

  def tags
    @posts = Post.filter_by_tag(params[:tags])
  end

  def successful_submitted; end
end
