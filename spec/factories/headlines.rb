FactoryBot.define do
  factory :headline do
    name { "FakeNews" }
    title { Faker::Lorem.sentence }
    url { "fakenews.com" }
    url_to_image { "generic_image.png" }
    published_at { Time.current }
  end
end