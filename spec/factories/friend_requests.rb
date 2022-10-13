FactoryBot.define do
  factory :friend_request do
    requester factory: :user
    requestee factory: :user
  end
end
