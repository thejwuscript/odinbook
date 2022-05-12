class FriendsController < ApplicationController
  def index
    @friends_list = current_user.friends
    @not_friends_list = current_user.not_friends
  end
end
