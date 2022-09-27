class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_one :notification, as: :notifiable, dependent: :destroy

  validates :post, uniqueness: { scope: :user }
end
