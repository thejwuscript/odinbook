class FriendRequest < ApplicationRecord
  belongs_to :requester, class_name: "User"
  belongs_to :requestee, class_name: "User", counter_cache: :received_requests_count

  validates :requester, uniqueness: { scope: :requestee }
end
