FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.sentence }

    post
    author factory: :user
  end
end
