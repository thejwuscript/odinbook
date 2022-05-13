class FriendsController < ApplicationController
  def index
    @friends_list = current_user.friends
  end
end
