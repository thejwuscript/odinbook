FactoryBot.define do
  factory :post do
    body { Faker::Lorem.sentence }

    author factory: :user
  end
end