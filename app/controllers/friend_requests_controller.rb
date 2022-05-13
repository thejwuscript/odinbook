class FriendRequestsController < ApplicationController
  def create
    request = current_user.sent_requests.build
    request.requestee = User.find(params[:user])
    if request.save
      redirect_to users_path, notice: 'Friend request sent successfully.'
    else
      redirect_to users_path, alert: 'Oops, something went wrong.'
    end
  end
end
