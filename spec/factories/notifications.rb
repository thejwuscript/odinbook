FactoryBot.define do
  factory :notification do
    sender factory: :user
    receiver factory: :user

    for_friend_request

    trait :for_friend_request do
      association :notifiable, factory: :friend_request
    end

    trait :for_friendship do
      association :notifiable, factory: :friendship
    end
  end
end
