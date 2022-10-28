require 'down'

USER_PASSWORD = ENV['USER_PASSWORD'].freeze

9.times do
  gender = %w[male female].sample
  first_name = gender == 'male' ? Faker::Name.male_first_name : Faker::Name.female_first_name
  last_name = Faker::Name.last_name
  username = "#{first_name}_#{last_name}".downcase
  email = Faker::Internet.email(name: first_name)

  user = User.create!(email:, username:, password: USER_PASSWORD, password_confirmation: USER_PASSWORD)

  image = Down.download("https://xsgames.co/randomusers/avatar.php?g=#{gender}")
  user.profile.avatar.attach(io: image, filename: "avatar#{user.profile.id}#{Time.current.hash}")
  user.profile.update!(display_name: "#{first_name} #{last_name}")
  3.times do
    user.posts.create(body: Faker::Lorem.paragraph(sentence_count: 2, supplemental: true, random_sentences_to_add: 4))
  end
end

test_user = User.create!(username: 'tester', email: 'test_user@example.com', password: 'password',
                         password_confirmation: 'password')
test_user.profile.update(display_name: 'Test User')
image = Down.download('https://xsgames.co/randomusers/avatar.php?g=male')
test_user.profile.avatar.attach(io: image, filename: "avatar#{test_user.profile.id}#{Time.current.hash}")

3.times do
  test_user.posts.create(body: Faker::Lorem.paragraph(sentence_count: 2, supplemental: true,
                                                      random_sentences_to_add: 4))
end

3.times do
  FriendRequest.create(requester: test_user, requestee: User.all.sample)
end

3.times do
  FriendRequest.create(requester: User.all.sample, requestee: test_user)
end

friendship = Friendship.create(user: User.first, friend: test_user)
Friendship.create(user: test_user, friend: User.first)
friendship.create_notification(sender: User.first, receiver: test_user)

30.times do
  Comment.create(
    body: Faker::Lorem.sentence(word_count: 3, supplemental: true, random_words_to_add: 4),
    author: User.all.sample,
    post: Post.all.sample
  )
end

40.times do
  Like.create(user: User.all.sample, post: Post.all.sample)
end
