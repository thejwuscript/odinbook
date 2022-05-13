class UsersController < ApplicationController
  def index
    @users = User.all_except(current_user)
    @friends_list = current_user.friends
    @not_friends_list = current_user.not_friends
    @potential_friends = FriendRequest.where(requester_id: current_user.id).map { |request| request.requestee }
  end
end
