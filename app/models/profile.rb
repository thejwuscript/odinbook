class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar
  validate :avatar_format
  validates :user, uniqueness: true

  def avatar_as_thumb
    avatar.variant(resize_to_limit: [300, 300]).processed
  end

  private

  def avatar_format
    return unless avatar.attached?
    return if avatar.content_type.in?(['image/jpeg', 'image/png'])
    
    errors.add(:avatar, 'Needs to be an image in .jpeg or .png format')
  end

end
