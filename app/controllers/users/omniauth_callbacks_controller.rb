class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :facebook

  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if Profile.find_by(user_id: @user).nil?
      @user.create_profile(request.env["omniauth.auth"])
    end

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      if is_navigational_format?
        set_flash_message(:notice, :success, kind: "Facebook")
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"].except(
        :extra
      ) # Removing extra as it can overflow some session stores
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
