class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :facebook

  def facebook
    auth = request.env['omniauth.auth']
    @user = User.from_omniauth(auth)
    if @user.persisted?
      @user.create_profile(Down.download(auth.info.image), auth.info.first_name) unless @user.profile

      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      session['devise.facebook_data'] = auth.except(:extra)
      redirect_to new_user_registration_url
    end
  end

  def back_to_homepage
    flash[:alert] = 'Please allow access to email address to sign in with Facebook.'
    failure
  end

  def failure
    redirect_to root_path
  end
end
