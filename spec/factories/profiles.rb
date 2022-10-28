FactoryBot.define do
  factory :profile do
    display_name { Faker::Name.unique.name }

    user
  end
end
