class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_writer :login

  has_many :sent_requests, class_name: "FriendRequest", foreign_key: :requester_id
  has_many :received_requests, class_name: "FriendRequest", foreign_key: :requestee_id
  has_many :friendships
  has_many :friends, through: :friendships

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
end