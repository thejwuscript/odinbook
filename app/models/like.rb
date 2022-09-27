class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_many :notifications, as: :notifiable

  validates :post, uniqueness: { scope: :user }
end
