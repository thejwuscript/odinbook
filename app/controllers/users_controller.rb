class UsersController < ApplicationController
  def index
    @users = User.all_except(current_user)
    @friends_list = current_user.friends
    @not_friends_list = current_user.not_friends
    @users_sent_requests_to = FriendRequest.where(requester_id: current_user.id).map { |request| request.requestee }
    @users_received_requests_from = FriendRequest.where(requestee_id: current_user.id).map { |request| request.requester }
    @potential_friends = @users_sent_requests_to + @users_received_requests_from
  end

  def show
    @user = User.find(params[:id])
    @profile = Profile.new
    @profile.user = @user
  end
end
