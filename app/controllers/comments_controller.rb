class CommentsController < ApplicationController
  def index
  end
  
  def new
    @post = Post.find(params[:post_id])
    render 'posts/comments/new'
  end

  def create
  end

  def minimize
    @post = Post.find(params[:post_id])
    render 'posts/comments/minimize'
  end
end
