# Odinbook
A Facebook clone that replicates the core user functionality of Facebook.

[Live demo](https://odinbook-xzzv.onrender.com/) 👈

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
- Docker
- RSpec + Capybara
- Postman

# Challenges
### Storing Friendships in the Database

I decided to create a separate table to store friendships for when friend requests were confirmed. I was met with the choice of storing one or two records per friendship. I considered the two options by weighing the pros and cons of each.

<img src="https://user-images.githubusercontent.com/88938117/199243437-7f32a32e-d2b2-4042-af61-5a9c63c638a3.png" alt="friendship tables" width="700">

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
There would be no need to write a custom method or write raw SQL to perform the same task. As a result, the code is clean and easy to understand.

Second, although friendships are mutual, each individual may view friendships differently than their counterpart. For example, User A may treat User B as a casual friend while User B sees User A as a close friend. This difference in perspective can be stored as a separate attribute for each record. Storing two records per friendship means that we can model the difference in perspective between two individuals.
### Facebook OAuth
When Facebook Login was first implemented, the app would crash whenever a user gave permission to their name and profile picture but denied access to their email address. What happened was the user was not saved to the database and the browser was redirected to load a page that needed the user's information. I considered several options to solve the problem:
  1. Allow users to sign up using a different email
  2. Redirect users back to the login page if they denied access to their facebook email address
  3. Allow the email attribute to be empty/null
  4. Switch out Devise for the BCrypt gem

Option #2 would be the easiest to implement without affecting other parts of the app. I would only need to add a guard clause to check if the user's email is present in the response from Facebook:
```ruby
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :facebook

  def facebook
    if request.env['omniauth.auth'].info.email.blank?
      flash[:alert] = 'Please allow access to email address to sign in with Facebook.'
      redirect_to root_path
      return
    end
    ... # more code here
  end
end
```
However, forcing users to provide their facebook email would not be a great user experience and should be avoided if possible.
Option #3 would break some built-in features of Devise that are useful such as password resets.
Option #4 would mean rolling my own authentication system, which may not be advisable when a well-tested authentication gem like Devise was already available.

The first option was the most flexible and secure solution. The [Devise documentation](https://github.com/heartcombo/devise/wiki/OmniAuth:-Overview) explains how to copy data from Facebook securely before a user creates an account. It is worth mentioning that Devise cleans up all session data starting with the "devise." key namespace whenever a user signs in.
### Custom Route
I had a custom route defined as the following:
```ruby
get ':username', to: 'users#show', as: :user
```
The route was working fine until a username like "earlean.shoope" was passed as the parameter, to which the server responded with a status of 500. Surprised at the outcome, I started debugging the issue by looking at the server log. I found out that the username parameter had been cut off at the dot.
```
Parameters: {"username" => "earlean.shoope"}    # expected

Parameters: {"username" => "earlean"}           # actual
```
It turns out that the parameter does not accept dots because the dot is used as a separator for formatted routes. As the [Rails documentation](https://guides.rubyonrails.org/routing.html#dynamic-segments) suggested, I added a constraint on the username to allow anything except a slash. The result:
```ruby
get ':username', to: 'users#show', constraints: { username: %r{[^/]+} }, as: :user
```
### Mocking API Calls
Because real HTTP requests are sent to the news API to render the homepage for logged in users, I needed to mock network requests for testing purposes. At first, I used [WebMock](https://github.com/bblimke/webmock) and [VCR](https://github.com/vcr/vcr) to record the response from the API as a snapshot that would be used for future requests. After I ran a few system tests however, I discovered that images were being downloaded from the web. This was not acceptable because downloading images slowed down the test significantly, wasted network resources, and made the test less deterministic. I also found out the snapshot produced by VCR contained extraneous data for my needs; I only needed a sample of the response body. Instead of relying on VCR, an external library that was counterproductive, I decided to use only WebMock to stub requests and return mocked responses to improve the quality of my tests.
