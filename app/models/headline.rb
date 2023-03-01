class Headline < ApplicationRecord
  validates :name, :title, :url, :published_at, presence: true
end
