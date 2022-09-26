require "down"

class PostsController < ApplicationController
  def index
    set_no_cache_headers
    if turbo_frame_request_id == 'new_post_frame'
      render partial: 'posts/new_post_placeholder'
    else
      current_user_posts = current_user.posts.includes(:likes)
      friends_posts =
        current_user
          .friends
          .includes(:posts)
          .flat_map { |friend| friend.posts.includes(:likes) }
      @timeline_posts =
        (current_user_posts + friends_posts)
          .sort_by { |post| post.created_at }
          .reverse
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    save_image

    if @post.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: "New post created." }
        format.turbo_stream { flash.now[:notice] = "New post created." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to root_path, status: :see_other, notice: 'Post was deleted successfully.' }
      format.turbo_stream { flash.now[:notice] = 'Post was deleted successfully.' }
    end
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end

  def save_image
    if params[:post][:image_url].present?
      tempfile = Down.download(params[:post][:image_url])
      @post.image.attach(io: tempfile, filename: "image#{@post.id}.jpg")
    elsif params[:post][:image_data_url].present?
      data_url = params[:post][:image_data_url].split(",")[1]
      @post.image.attach(
        io: StringIO.new(Base64.decode64(data_url)),
        filename: "image#{@post.id}.jpg"
      )
    end
  end
end
