class Post < ApplicationRecord
  belongs_to :author, class_name: "User"
  validates :body, presence: true
end
