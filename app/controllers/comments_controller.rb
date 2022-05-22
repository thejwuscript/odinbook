class CommentsController < ApplicationController
  def new
    @comment = current_user.comments.build
    @comment.post = Post.find(params[:post_id])
  end

  def create
  end
end
