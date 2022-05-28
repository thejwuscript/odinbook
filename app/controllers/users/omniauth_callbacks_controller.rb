require 'open-uri'

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :facebook

  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])
    file = URI.parse(request.env["omniauth.auth"].info.image).open
    profile = Profile.find_by(user: @user) || Profile.create(user: @user)
    profile.avatar.attach(io: file, filename: "user_avatar")
    file.close

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end


end