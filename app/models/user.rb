require 'down'
require 'securerandom'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :omniauthable,
         omniauth_providers: %i[facebook]

  attr_writer :login

  has_many :sent_requests,
           class_name: 'FriendRequest',
           foreign_key: :requester_id,
           dependent: :destroy
  has_many :received_requests,
           class_name: 'FriendRequest',
           foreign_key: :requestee_id,
           dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :posts, foreign_key: :author_id, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, foreign_key: :author_id, dependent: :destroy
  has_many :sent_notifications, foreign_key: 'sender_id', class_name: 'Notification', dependent: :destroy
  has_many :received_notifications, foreign_key: 'receiver_id', class_name: 'Notification', dependent: :destroy
  has_one :profile, dependent: :destroy
  delegate :avatar, to: :profile

  validates :username, length: { maximum: 50 }, uniqueness: true, presence: true
  validates :email, length: { maximum: 50 }

  after_create :create_profile, unless: :omniauth_provider?

  after_create :send_welcome_email

  scope :all_except, ->(user) { where.not(id: user) }

  def login
    @login || username || email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(
        [
          'lower(username) = :value OR lower(email) = :value',
          { value: login.downcase }
        ]
      ).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def not_friends
    User.all_except(self).to_a.difference(friends.to_a)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.username = "#{auth.info.name.downcase.gsub(/\s+/, '.')}#{SecureRandom.random_number(10_000)}"
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if (data = session['devise.facebook_data'])
        user.provider = data['provider']
        user.uid = data['uid']
        profile = user.build_profile(display_name: data['info']['first_name'])
        profile.avatar.attach(
          io: Down.download(data['info']['image']),
          filename: "fb_avatar_#{profile.id}",
          content_type: 'image/jpeg'
        )
      end
    end
  end

  def omniauth_provider?
    provider
  end

  def create_profile(avatar_file = nil, display_name = nil)
    profile = Profile.create!(user: self, display_name:)
    profile.avatar.attach(
      io: (avatar_file || File.open("#{Rails.root}/app/assets/images/head_avatar.jpg")),
      filename: "avatar#{profile.id}#{Time.current.hash}",
      content_type: 'image/jpeg'
    )
  end

  def name
    profile.nil? || profile.display_name.blank? ? username : profile.display_name
  end

  def send_welcome_email
    return unless persisted?

    UserMailer.with(user: self).welcome_email.deliver_now
  end
end
