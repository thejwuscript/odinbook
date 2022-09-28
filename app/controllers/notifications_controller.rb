class NotificationsController < ApplicationController
  def index
  end

  def create
  end

  def destroy
  end

  def read_all
    respond_to do |format|
      format.turbo_stream
    end
  end
end
