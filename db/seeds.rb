require 'down'
require 'faker'

USER_PASSWORD = ENV['USER_PASSWORD'].freeze


def seed_database
  # Create the test user

  test_user = User.create!(username: 'tester', email: 'test_user@example.com', password: 'password',
                           password_confirmation: 'password')
  test_user.profile.update(display_name: 'Test User')
  image = Down.download('https://xsgames.co/randomusers/avatar.php?g=male')
  test_user.profile.avatar.attach(io: image, filename: "avatar#{test_user.profile.id}#{Time.current.hash}")

end

seed_database if User.first.nil?
