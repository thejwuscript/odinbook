require "browser"

class ApplicationController < ActionController::Base

  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :load_notifications, if: :user_signed_in?

  protected

  def configure_permitted_parameters
    added_attrs = %i[username email password password_confirmation remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: %i[login password]
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def load_notifications
    @notifications = current_user.received_notifications
    @unread_count = @notifications.where(user_read: false).count
  end

  def set_no_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Tue, 01 Jan 2002 00:00:00 UTC"
  end

  def after_sign_in_path_for(resource)
    root_url if resource.is_a?(User)
  end

  private

  def user_not_authorized
    respond_to do |format|
      format.turbo_stream do
        flash.now[:alert] = 'You are not authorized to perform this action.'
        render turbo_stream: turbo_stream.prepend('root', partial: 'shared/flash')
      end
      format.html do
        flash[:alert] = 'You are not authorized to perform this action.'
        redirect_back_or_to(root_path)
      end
    end
  end
end
