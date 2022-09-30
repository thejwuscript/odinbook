class FriendRequest < ApplicationRecord
  belongs_to :requester, class_name: "User"
  belongs_to :requestee,
             class_name: "User",
             counter_cache: :received_requests_count
  has_one :notification, as: :notifiable

  validates :requester, uniqueness: { scope: :requestee }

  after_create -> { create_notification(sender: requester, receiver: requestee) }
end
