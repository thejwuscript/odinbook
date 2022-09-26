class FriendshipsController < ApplicationController
  def index
    @friendships = Friendship.where(user: current_user)
  end
  
  def create
    friend = User.find(params[:friend_id])
    friendship_a = current_user.friendships.build(friend: friend)
    friendship_b = friend.friendships.build(friend: current_user)
    if friendship_a.save && friendship_b.save
      FriendRequest.find(params[:request_id]).destroy
      redirect_to friendships_path, notice: "Great, you've added a new friend!"
    else
      redirect_to friendships_path, alert: "Oops, something went wrong."
    end
  end

  def destroy
  end
end
