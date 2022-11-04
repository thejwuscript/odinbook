class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :facebook

  def facebook
    return back_to_homepage if request.env['omniauth.auth'].info.email.blank?

    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      session['devise.facebook_data'] = request.env['omniauth.auth'].except(
        :extra
      ) # Removing extra as it can overflow some session stores
      redirect_to new_user_registration_url
    end
  end

  def back_to_homepage
    flash[:alert] = 'Please allow access to email address to sign in with Facebook.'
    redirect_to root_path
  end
end
