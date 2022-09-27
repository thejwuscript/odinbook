class Headline < ApplicationRecord
  validates :name, :title, :url, :url_to_image, :published_at, presence: true
end
