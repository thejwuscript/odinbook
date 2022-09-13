class ProfilesController < ApplicationController
  def show
    redirect_to user_path(current_user)
  end

  def new
  end

  def create
  end

  def edit
    @profile = Profile.find_by(user_id: current_user)
  end

  def update
    @profile = Profile.find_by(user_id: current_user)

    if @profile.update(profile_params)
      redirect_to user_path(username: current_user.username)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    puts "called here"
  end

  private

  def profile_params
    params.require(:profile).permit(:display_name, :bio, :company, :location, :avatar, :cover_photo)
  end
end
