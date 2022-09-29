class NotificationsController < ApplicationController
  def index
  end

  def create
  end

  def destroy
    @notifications = Notification.where(id: params[:ids])
    @notification = Notification.find(params[:id])
    @notification.destroy

    respond_to do |format|
      format.turbo_stream
    end
  end

  def clear_all_loaded
    @notifications = Notification.where(id: params[:ids])
    @notifications.destroy_all

    respond_to do |format|
      format.turbo_stream
    end
  end

  def read_all
    @notifications = Notification.where(id: params[:ids])
    @notifications.where(user_read: false).update_all(user_read: true)
    respond_to do |format|
      format.turbo_stream
    end
  end
end
