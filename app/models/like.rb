class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user
  # has_one :notification, as: :notifiable

  validates :post, uniqueness: { scope: :user }
end
