class Post < ApplicationRecord
  has_one_attached :image
  belongs_to :author, class_name: "User"
  validates :body, presence: true

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
end
