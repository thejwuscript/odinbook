# Odinbook
A Facebook clone that replicates the core user functionality of Facebook.

[Live demo](https://evening-sands-32189.herokuapp.com/) 👈

# Preview

![preview_gif](https://user-images.githubusercontent.com/88938117/199010744-a45cdf0e-be2f-420b-8e42-5265399d6206.gif)

# Features

- Sign in with Facebook
- Create posts with image attachment
- View relevant posts in chronological order
- Create own Profile
- Friends and Friend Requests
- Likes and Comments
- Notifications
- View recent news headlines
- Responsive design

# Technologies used

- HTML5
- CSS3
- JavaScript
- Ruby
- Ruby on Rails
- Hotwire (Turbo & Stimulus)
- PostgreSQL
- AWS S3
- RSpec + Capybara
- Heroku

# Challenges
### Storing Friendships in the Database

I decided to create a separate table to store friendships for when friend requests were confirmed. I was met with the choice of storing one or two records per friendship. I considered the two options by weighing the pros and cons of each.

<img src="https://user-images.githubusercontent.com/88938117/199243437-7f32a32e-d2b2-4042-af61-5a9c63c638a3.png" alt="friendship tables" width="80%">

I went with creating two records per friendship despite the redundancy for a couple of reasons. First, I can use the query ```user.friends``` to retrive a list of friends for a particular user by leveraging Active Record associations.
```ruby
class User < ApplicationRecord
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
end

class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'
end
```
There would be no need to write a custom method or write raw SQL to perform the same task. As a result, the code is cleaner and easier to understand.

Second, although friendships are mutual, each individual may view friendships differently than their counterpart. For example, User A may treat User B as a casual friend while User B sees User A as a close friend. This difference in perspective can be stored as a separate attribute for each record. Storing two records per friendship means that we can model the difference in perspective between two individuals.
### Custom Route
I had a custom route defined like so:
```ruby
get ':username', to: 'users#show', as: :user
```
The route was working fine until the username "earlean.shoope" was passed as the parameter, to which the server responded with a status of 500. Surprised at the outcome, I started debugging the issue by looking at the server log. I found out that the username parameter had been cut off at the dot.
```
Parameters: {"username" => "earlean.shoope"}    # expected

Parameters: {"username" => "earlean"}           # actual
```
It turns out that the parameter does not accept dots because the dot is used as a separator for formatted routes. As the [Rails documentation](https://guides.rubyonrails.org/routing.html#dynamic-segments) suggested, I added a constraint on the username to allow anything except a slash. The result:
```ruby
get ':username', to: 'users#show', constraints: { username: %r{[^/]+} }, as: :user
```
### Facebook OAuth2
When Facebook Login was first implemented, the app would crash when users gave permission to name and profile picture but denied access to email address.  User registation could not be completed without an email address but my app proceeded to load a page that needed current user information. I considered several options to solve this problem:
  1. Add a guard clause for denied access to email address
  2. Change the default configuration of Devise
  3. Switch to BCrypt or another authentication gem
