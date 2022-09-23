require 'down'

USER_PASSWORD = 'password'.freeze

6.times do
  gender = ['male', 'female'].sample
  first_name = gender == 'male' ? Faker::Name.male_first_name : Faker::Name.female_first_name
  last_name = Faker::Name.last_name
  username = "#{first_name}_#{last_name}".downcase
  email = Faker::Internet.email(name: first_name)

  user = User.create!(email:, username:, password: USER_PASSWORD, password_confirmation: USER_PASSWORD)

  image = Down.download("https://xsgames.co/randomusers/avatar.php?g=#{gender}")
  user.profile.avatar.attach(io: image, filename: "avatar#{user.profile.id}#{Time.current.hash}")
  user.profile.update!(display_name: "#{first_name} #{last_name}")
  2.times do
    user.posts.create(body: Faker::Lorem.paragraph(sentence_count: 2, supplemental: true, random_sentences_to_add: 4))
  end
end

admin = User.create!(username: 'admin', email: 'admin@example.com', password: USER_PASSWORD,
                     password_confirmation: USER_PASSWORD)
image = Down.download("https://xsgames.co/randomusers/avatar.php?g=male")
admin.profile.avatar.attach(io: image, filename: "avatar#{admin.profile.id}#{Time.current.hash}")
3.times do
  admin.posts.create(body: Faker::Lorem.paragraph(sentence_count: 2, supplemental: true, random_sentences_to_add: 4))
end
