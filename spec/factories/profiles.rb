FactoryBot.define do
  factory :profile do
    display_name { Faker::Name.name }

    association :user
  end
end