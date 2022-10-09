FactoryBot.define do
  factory :user do
    email { 'test_email@example.com' }
    username { 'test_username@example.com' }
    password { '123456' }
  end
end
