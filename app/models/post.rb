class Post < ApplicationRecord
  validates :body, presence: true

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :image, dependent: :destroy

  belongs_to :author, class_name: 'User'
end
