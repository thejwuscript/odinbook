class FriendRequestsController < ApplicationController
  def index
    @received_requests =
      current_user.received_requests.includes(:requester, :requestee)
  end
  
  def create
    request = current_user.sent_requests.build
    request.requestee = User.find(params[:user])
    if request.save
      redirect_to users_path, notice: "Friend request sent successfully."
    else
      redirect_to users_path, alert: "Oops, something went wrong."
    end
  end

  def destroy
    request = FriendRequest.find(params[:id])
    request.destroy
    redirect_to friend_requests_path,
                status: :see_other,
                notice: "Friend request deleted."
  end
end
