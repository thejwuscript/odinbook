class Friendship < ApplicationRecord
  after_destroy do |friendship|
    Friendship.where(friend_id: friendship.user.id).delete_all
  end

  belongs_to :user
  belongs_to :friend, class_name: "User"
  has_one :notification, as: :notifiable, dependent: :destroy

  validates :friend, uniqueness: { scope: :user }
end
