class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"
  has_one :notification, as: :notifiable

  validates :friend, uniqueness: { scope: :user }

  after_create :destroy_friend_requests

  private

  def destroy_friend_requests
    FriendRequest.find_by(requester: user, requestee: friend)&.destroy
    FriendRequest.find_by(requester: friend, requestee: user)&.destroy
  end
end
