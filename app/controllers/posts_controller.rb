class PostsController < ApplicationController
  def index
    current_user_posts = current_user.posts.includes(:likes)
    friends_posts = current_user.friends.includes(:posts).flat_map { |friend| friend.posts.includes(:likes) }
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
    params.require(:post).permit(:body, :image_url)
  end

end
