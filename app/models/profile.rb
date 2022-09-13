class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [300, 300]
  end
  has_one_attached :cover_photo
  validate :avatar_format
  validates :user, uniqueness: true

  private

  def avatar_format
    return unless avatar.attached?
    return if avatar.content_type.in?(%w[image/jpeg image/png])

    errors.add(:avatar, "Needs to be an image in .jpeg or .png format")
  end
end
