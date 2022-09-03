# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
USER_PASSWORD = "password"

10.times do
  user = User.create!(Faker::Internet.unique.user.merge({password: USER_PASSWORD, password_confirmation: USER_PASSWORD}))
  image = Down.download(Faker::Avatar.unique.image(size: "50x50"))
  user.profile.avatar.attach(io: image, filename: "avatar")
  user.profile.update!(display_name: Faker::Name.unique.name)
end

admin = User.create!(username: "admin", email: "admin@example.com", password: USER_PASSWORD, password_confirmation: USER_PASSWORD)
image = Down.download(Faker::Avatar.unique.image(size: "50x50"))
admin.profile.avatar.attach(io: image, filename: "avatar")
