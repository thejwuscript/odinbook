class FriendRequest < ApplicationRecord
  belongs_to :requester, class_name: "User"
  belongs_to :requestee,
             class_name: "User",
             counter_cache: :received_requests_count
  has_one :notification, as: :notifiable

  validates :requester, uniqueness: { scope: :requestee }

  validate :cannot_send_reciprocal_friend_request, :cannot_send_request_to_self

  after_create -> { create_notification(sender: requester, receiver: requestee) }

  def cannot_send_reciprocal_friend_request
    if FriendRequest.find_by(requester: requestee, requestee: requester)
      errors.add(:base, "Please confirm the friend request from #{requestee.name}.")
    end
  end

  def cannot_send_request_to_self
    if requester == requestee
      errors.add(:base, "Cannot send a friend request to youself.")
    end
  end
end
