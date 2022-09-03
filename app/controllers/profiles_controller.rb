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
    #include hidden field for user id
  end

  def update
    @profile = Profile.find_by(user_id: current_user)

    if @profile.update(profile_params)
      redirect_to user_path(current_user)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def profile_params
    params.require(:profile).permit(:display_name, :bio, :gender, :location, :birthday, :avatar)
  end
end
