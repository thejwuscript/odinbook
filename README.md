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

I decided to create a separate table to store friendships after a confirmed friend request. A friendship between user A and user B would be stored as a record in the table, but I was not sure if I should create another record to represent the friendship in the other direction.

<img src="https://user-images.githubusercontent.com/88938117/199243437-7f32a32e-d2b2-4042-af61-5a9c63c638a3.png" alt="friendship tables" width="80%">

I went with creating two records per friendship despite the redundancy for a couple of reasons. First, I can use the query ```user.friends``` to retrive a list of friends for a particular user by leveraging Active Record associations. There would be no need to chain query methods or write raw SQL to perform the same task. As a result, the code is cleaner and easier to understand.

```
class User < ApplicationRecord
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
end

class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'
end
```
Second, although friendships are mutual, each individual may view friendships differently than their counterpart. For example, User A may treat User B as a casual friend while User B sees User A as a close friend. This difference in perspective can be stored as a separate attribute for each record. Storing two records per friendship means that we can model the difference in perspective between two individuals. 