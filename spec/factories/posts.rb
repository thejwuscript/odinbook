FactoryBot.define do
  factory :post do
    body { Faker::Lorem.unique.sentence }

    author factory: :user
  end
end
