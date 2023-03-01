require 'down'
require 'news-api'

class PostsController < ApplicationController
  def index
    set_no_cache_headers
    if turbo_frame_request_id == 'new_post_frame'
      render partial: 'posts/new_post_placeholder'
    else
      current_user_posts = Post.includes(:author, :image_attachment, :comments, :likes, likes: :user)
                               .where(author: current_user)
      friends_posts =
        current_user
        .friends
        .flat_map { |friend| friend.posts.includes(:author, :image_attachment, :comments, :likes, likes: :user) }
      @timeline_posts =
        (current_user_posts + friends_posts)
        .sort_by { |post| post.created_at }
        .reverse
      unless Headline.first && ((Time.current - Headline.first.updated_at) / 1.hour).round < 12
        Headline.destroy_all
        news = News.new(ENV['NEWS_API_KEY'])
        news.get_top_headlines(country: 'jp').each do |headline|
          Headline.create(
            name: headline.name,
            title: headline.title,
            url: headline.url,
            url_to_image: headline.urlToImage,
            published_at: headline.publishedAt
          )
          break if Headline.count >= 3
        end
      end
      @headlines = Headline.all
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params.except(:image_data_url))
    process_image_attachment

    if @post.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'New post created.' }
        format.turbo_stream { flash.now[:notice] = 'New post created.' }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = Post.find(params[:id])
    authorize @post
  end

  def update
    @post = Post.find(params[:id])
    authorize @post

    if @post.update(post_params.except(:image_data_url))
      process_image_attachment

      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Post was successfully updated.' }
        format.turbo_stream { flash.now[:notice] = 'Post was successfully updated.' }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    authorize @post
    @post.destroy

    respond_to do |format|
      format.html { redirect_to root_path, status: :see_other, notice: 'Post was deleted successfully.' }
      format.turbo_stream { flash.now[:notice] = 'Post was deleted successfully.' }
    end
  end

  private

  def post_params
    params.require(:post).permit(:body, :image_url, :image_data_url)
  end

  def process_image_attachment
    image_data_url = params[:post][:image_data_url]
    if image_data_url == 'attached'
      return
    elsif params[:post][:image_data_url].present?
      create_or_update_image_attachment
    elsif params[:post][:image_data_url].empty?
      delete_image_attachment
    end
  end

  def create_or_update_image_attachment
    data_url = params[:post][:image_data_url].split(',')[1]
    @post.image.attach(
      io: StringIO.new(Base64.decode64(data_url)),
      filename: "image#{@post.id}.jpg"
    )
  end

  def delete_image_attachment
    @post.image.purge
  end
end
