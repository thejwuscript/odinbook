class PostsController < ApplicationController
  def index
    current_user_posts = Post.where(author_id: current_user.id)
    friends_posts = current_user.friends.flat_map do |friend|
      Post.where(author_id: friend.id)
    end
    @timeline_posts = (current_user_posts + friends_posts).sort_by { |post| post.created_at}.reverse
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: "New post created." }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end

end
