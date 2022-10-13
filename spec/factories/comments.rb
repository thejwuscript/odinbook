FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.unique.sentence }

    post
    author factory: :user
  end
end
