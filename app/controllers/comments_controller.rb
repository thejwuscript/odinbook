class CommentsController < ApplicationController
  skip_before_action :count_friend_requests

  def index

  end
  
  def new
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(author: current_user)
    @post_comments = @post.comments.all
    render 'posts/comments/new'
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(author: current_user, body: comment_params[:body])

    if @comment.save
      respond_to do |format|
        format.html {}
        format.turbo_stream { redirect_to new_post_comment_path }
      end
    else
      render 'posts/comments/new', status: :unprocessable_entity
    end
  end

  def minimize
    @post = Post.find(params[:post_id])
    render 'posts/comments/minimize'
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :post_id)
  end

end
