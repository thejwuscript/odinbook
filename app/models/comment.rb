class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :post
  # has_one :notification, as: :notifiable
  validates :body, presence: true
end
