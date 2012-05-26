# encoding: utf-8
class PostsController < ApplicationController
  load_and_authorize_resource
  before_filter :authenticate_user!
  respond_to :html

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(params[:post])
    if @post.save
      redirect_to successful_submitted_posts_path
    else
      render 'new'
    end
  end

  def successful_submitted; end
end
