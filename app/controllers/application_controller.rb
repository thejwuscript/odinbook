class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :count_friend_requests, if: :user_signed_in?

  protected

  def configure_permitted_parameters
    added_attrs = %i[username email password password_confirmation remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: %i[login password]
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def count_friend_requests
    #@count = FriendRequest.where(requestee: current_user).count
    @count = current_user.received_requests.size
  end

  def set_no_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Tue, 01 Jan 2002 00:00:00 UTC"
  end

  def after_sign_in_path_for(resource)
    root_url if resource.is_a?(User)
  end
end
