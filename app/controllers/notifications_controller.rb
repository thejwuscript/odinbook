class NotificationsController < ApplicationController
  def index
  end

  def create
  end

  def destroy
  end

  def read_all
    @notifications = Notification.where(id: params[:unread_ids])
    respond_to do |format|
      format.turbo_stream
    end
  end
end
