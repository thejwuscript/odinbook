class FriendsController < ApplicationController
  def index
    @friends_list = current_user.friends
    @received_requests = current_user.received_requests.includes(:requester, :requestee)
  end
end
