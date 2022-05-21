class LikesController < ApplicationController
  def create
    @post = Post.find(params[:id])
    @like = @post.likes.build(user: current_user)

    if @like.save
      respond_to do |format|
        format.html {}
        format.turbo_stream
      end
    else
      flash.now[:alert] = 'You can only like each post once.'
      render "/likes/create", status: :unprocessable_entity
    end
  end
end
