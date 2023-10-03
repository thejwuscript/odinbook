FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    username { Faker::Internet.unique.username(specifier: 6..12) }
    password { '123456' }
    password_confirmation { '123456' }
  end
end
