class FriendRequest < ApplicationRecord
  belongs_to :requester, class_name: "User"
  belongs_to :requestee, class_name: "User"

  validates :requester, uniqueness: { scope: :requestee }
end
