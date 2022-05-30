require 'securerandom'
require 'down'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[facebook]

  attr_writer :login

  has_many :sent_requests, class_name: "FriendRequest", foreign_key: :requester_id, dependent: :destroy
  has_many :received_requests, class_name: "FriendRequest", foreign_key: :requestee_id, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :posts, foreign_key: :author_id, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, foreign_key: :author_id, dependent: :destroy
  has_one :profile, dependent: :destroy

  after_create :create_profile, :send_welcome_email

  scope :all_except, ->(user) { where.not(id: user) }

  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def not_friends
    User.all_except(self).to_a.difference(self.friends.to_a)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.username = "#{auth.info.email[/^[^@]+/]}-#{SecureRandom.random_number(100)}"
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def create_profile(auth = nil)
    profile = Profile.create!(user: self)
    return unless auth
    
    profile.first_name = auth.info.first_name
    profile.last_name = auth.info.last_name
    image = Down.download(auth.info.image)
    profile.avatar.attach(io: image, filename: "avatar")
  end

  def name
    profile = Profile.find_by(user_id: self)
    if (profile.nil? || profile.first_name.blank?)
      username
    else
      profile.first_name
    end
  end

  def avatar
    if profile && profile.avatar.attached?
      profile.avatar
    else
      "head_avatar.jpg"
    end
  end

  def send_welcome_email
    return unless persisted?
    
    UserMailer.with(user: self).welcome_email.deliver_now
  end
end

