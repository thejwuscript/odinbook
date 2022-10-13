require 'rails_helper'

RSpec.describe User, type: :model do
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

  context 'when a user is created' do
    subject(:user) { build(:user) }

    it 'calls #create_profile by default' do
      expect(user).to receive(:create_profile).once
      user.save
    end

    it 'does not call #create_profile if it is a facebook user' do
      user.provider = 'facebook'
      expect(user).not_to receive(:create_profile)
      user.save
    end

    it 'calls #send_welcome_email' do
      expect(user).to receive(:send_welcome_email).once
      user.save
    end
  end

  describe '.all_except' do
    subject(:user) { create(:user) }

    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }

    it 'returns a list of all users except for the specified user', :aggregate_failures do
      list = described_class.all_except(user)
      expect(list).to include(user1, user2)
      expect(list).not_to include(user)
    end
  end

  describe '#create_profile' do
    subject(:user) { create(:user) }

    it 'creates a profile for the user' do
      expect(user.profile).to be_present
    end

    it 'attaches an avatar photo to profile' do
      expect(user.profile.avatar.attached?).to be true
    end
  end

  describe '#send_welcome_email' do
    subject(:user) { create(:user) }

    let(:mail) { instance_double(ActionMailer::MessageDelivery) }

    before do
      allow(UserMailer).to receive(:with).and_return(UserMailer)
      allow(UserMailer).to receive(:welcome_email).and_return(mail)
      allow(mail).to receive(:deliver_now)
    end

    it 'sends a message welcome_email to UserMailer' do
      expect(UserMailer).to receive(:welcome_email)
      user.send_welcome_email
    end
  end

  describe '#not_friends' do
    subject(:user) { create(:user) }

    let!(:friend1) { create(:user) }
    let!(:stranger1) { create(:user) }
    let!(:stranger2) { create(:user) }

    before do
      user.friends << friend1
    end

    it 'returns a list of users who are not friends' do
      result = user.not_friends
      expect(result).to include(stranger1, stranger2)
    end

    it 'does not include users who are friends' do
      result = user.not_friends
      expect(result).not_to include(friend1)
    end
  end

  describe '#name' do
    subject(:user) { build(:user) }

    context 'when the user profile is not created yet' do
      it 'returns the username' do
        expect(user.name).to eq(user.username)
      end
    end

    context 'when the profile display name is blank' do
      before do
        user.save
        user.profile.display_name = nil
      end

      it 'returns the username' do
        expect(user.name).to eq(user.username)
      end
    end

    context 'when the profile display name exist' do
      before do
        user.save
        user.profile.display_name = 'Tester'
      end

      it 'returns the display name' do
        expect(user.name).to eq('Tester')
      end
    end
  end
end
