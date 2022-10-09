require 'rails_helper'

RSpec.describe User, type: :model do
  context 'testing validations' do
    subject(:user) { build(:user) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:password) }

    it { is_expected.to validate_confirmation_of(:password) }

    it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { is_expected.to validate_uniqueness_of(:username) }

    it { is_expected.to validate_length_of(:email).is_at_most(50) }
    it { is_expected.to validate_length_of(:username).is_at_most(50) }
    it { is_expected.to validate_length_of(:password).is_at_least(6).is_at_most(128) }
  end

  context 'testing associations' do
    it { is_expected.to have_one(:profile).dependent(:destroy) }
    it { is_expected.to have_many(:sent_requests).class_name(:FriendRequest).dependent(:destroy) }
    it { is_expected.to have_many(:received_requests).class_name(:FriendRequest).dependent(:destroy) }
    it { is_expected.to have_many(:friendships) }
    it { is_expected.to have_many(:friends).through(:friendships) }
    it { is_expected.to have_many(:posts).dependent(:destroy) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:sent_notifications).class_name(:Notification).dependent(:destroy) }
    it { is_expected.to have_many(:received_notifications).class_name(:Notification).dependent(:destroy) }
  end
end
