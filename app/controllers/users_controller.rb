class UsersController < ApplicationController
  def index
    @users = User.all_except(current_user).order(:username)
    @friends_list = current_user.friends
    @not_friends_list = current_user.not_friends
    @sent_requests_users =
      FriendRequest
      .where(requester_id: current_user.id)
      .includes(:requestee)
      .map { |request| request.requestee }
    @received_requests = FriendRequest.where(requestee_id: current_user.id).includes(:requester)
    @received_requests_users = @received_requests.map { |request| request.requester }
    @potential_friends = @sent_requests_users + @received_requests_users
  end

  def show
    if params.key?(:username)
      @user = User.find_by(username: params[:username])
      @profile = Profile.find_by(user_id: @user) || Profile.create(user: @user)
      @posts = Post.where(author: @user).order(created_at: :desc)
    else
      # user not found
    end
  end
end
