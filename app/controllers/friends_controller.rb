class FriendsController < ApplicationController
  def index
    @friends_list = current_user.friends
    @not_friends_list = current_user.not_friends
    @potential_friends = FriendRequest.where(requester_id: current_user.id).map { |request| request.requestee }
  end
end
