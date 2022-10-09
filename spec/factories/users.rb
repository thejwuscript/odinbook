FactoryBot.define do
  factory :user do
    email { Faker::Internet.safe_email }
    username { Faker::Internet.username(specifier: 6..12) }
    password { '123456' }
    password_confirmation { '123456' }
  end
end
