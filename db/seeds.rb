USER_PASSWORD = 'password'.freeze

10.times do
  user = User.create!(Faker::Internet.unique.user.merge({ password: USER_PASSWORD,
                                                          password_confirmation: USER_PASSWORD }))
  image = File.open("#{Rails.root}/app/assets/images/head_avatar.jpg")
  user.profile.avatar.attach(io: image, filename: "avatar#{user.profile.id}#{Time.current.hash}")
  user.profile.update!(display_name: Faker::Name.unique.name)
  3.times do
    user.posts.create(body: Faker::Lorem.paragraph(sentence_count: 2, supplemental: true, random_sentences_to_add: 4))
  end
end

admin = User.create!(username: 'admin', email: 'admin@example.com', password: USER_PASSWORD,
                     password_confirmation: USER_PASSWORD)
image = Down.download(Faker::Avatar.unique.image(size: '300x300'))
admin.profile.avatar.attach(io: image, filename: "avatar#{admin.profile.id}#{Time.current.hash}")
3.times do
  admin.posts.create(body: Faker::Lorem.paragraph(sentence_count: 2, supplemental: true, random_sentences_to_add: 4))
end
