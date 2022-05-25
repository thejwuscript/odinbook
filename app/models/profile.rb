class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar

  def avatar_as_thumb
    avatar.variant(resize_to_limit: [300, 300]).processed
  end

end
