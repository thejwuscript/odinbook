class Post < ApplicationRecord
  validates :body, presence: true

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :image, dependent: :destroy
  validate :image_format

  belongs_to :author, class_name: 'User'

  private

  def image_format
    return unless image.attached?
    return if image.content_type.in?(%w[image/jpeg image/png])

    image.purge
    errors.add(:avatar, "Needs to be an image in .jpeg or .png format")
  end
end
