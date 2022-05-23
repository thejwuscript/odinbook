class CommentsController < ApplicationController
  skip_before_action :count_friend_requests

  def index
  end
  
  def new
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(author: current_user)
    render 'posts/comments/new'
  end

  def create
  end

  def minimize
    @post = Post.find(params[:post_id])
    render 'posts/comments/minimize'
  end
end
