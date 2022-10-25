class CommentsController < ApplicationController
  skip_before_action :load_notifications

  def index
    @comments = Comment.where(post_id: params[:post_id])

    respond_to do |format|
      format.json { render json: { currentUserId: current_user.id, comments: @comments } }
    end
  end

  def new
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(author: current_user)
    @post_comments = @post.comments.all.order(created_at: :desc)
    @post_comments_data = @post_comments.to_a.map do |comment|
      hash = {}
      hash[:id] = comment.id
      hash[:authorId] = comment.author.id
      hash[:author] = comment.author.name
      hash[:body] = comment.body
      hash[:postId] = comment.post.id
      hash[:createdAt] = comment.created_at
      hash
    end
    @avatar = current_user.avatar
    # render "posts/comments/new"
    respond_to do |format|
      format.json { render json: { currentUserId: current_user.id, name: current_user.name, post: @post, imageUrl: url_for(@avatar), newComment: @comment, postComments: @post_comments_data }}
      format.html { render "posts/comments/new" }
    end
  end

  def create
    @post = Post.find(params[:post_id])
    @comment =
      @post.comments.build(author: current_user, body: comment_params[:body])

    if @comment.save
      respond_to do |format|
        format.json { render json: @comment }
        # format.turbo_stream { render "posts/comments/create" }
      end
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    @post = @comment.post
    @avatar = current_user.avatar
  end

  def update
    @comment = Comment.find(params[:id])
    @post = @comment.post
    @avatar = current_user.avatar

    if @comment.update(comment_params)
      # redirect? turbo stream?
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def minimize
    @post = Post.find(params[:post_id])
    render "posts/comments/minimize"
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :post_id)
  end
end
