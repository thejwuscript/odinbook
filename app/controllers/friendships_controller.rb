class FriendshipsController < ApplicationController
  def index
    @friendships = Friendship.where(user: current_user)
  end

  def create
    friend = User.find(params[:friend_id])
    friendship_a = current_user.friendships.build(friend:)
    friendship_b = friend.friendships.build(friend: current_user)

    if friendship_a.save && friendship_b.save
      friendship_a.create_notification(sender: current_user, receiver: friend)
      redirect_to friends_path, notice: "Great, you've added a new friend!"
    else
      redirect_to friends_path, alert: "Cannot add #{friend.name} as a friend."
    end
  end

  def destroy
    @friendship_a = Friendship.find(params[:id])
    @friendship_b = Friendship.find_by(user: @friendship_a.friend, friend: @friendship_a.user)

    @friendship_a.destroy
    @friendship_b.destroy

    flash[:notice] = 'Removed friend successfully.'
    redirect_to friends_path, status: :see_other
  end
end
