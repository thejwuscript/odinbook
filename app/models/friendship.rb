class Friendship < ApplicationRecord
  after_destroy do |friendship|
    Friendship.where(friend_id: friendship.user.id).delete_all
  end

  belongs_to :user
  belongs_to :friend, class_name: "User"
  has_many :notifications, as: :notifiable

  validates :friend, uniqueness: { scope: :user }

  #def destroy
  #  list = Friendship.where(user_id: user.id).or(Friendship.where(friend_id: user.id))
  #  list.delete_all
  #end
end
