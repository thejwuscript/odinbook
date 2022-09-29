class NotificationsController < ApplicationController
  def index
  end

  def create
  end

  def destroy
    puts "destroy!!!!"
  end

  def read_all
    @notifications = Notification.where(id: params[:ids])
    @notifications.where(user_read: false).update_all(user_read: true)
    p @notifications
    respond_to do |format|
      format.turbo_stream
    end
  end
end
