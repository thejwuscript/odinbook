require 'rails_helper'

RSpec.describe Notification, type: :model do
  context 'when the notifiable type is FriendRequest' do
    subject(:notification) { create(:notification, :for_friend_request) }

    it 'saves the expected string in the message attribute' do
      result = notification.message
      name = notification.sender.name
      expect(result).to eq("#{name} sent you a friend request.")
    end
  end

  context 'when the notifiable type is Friendship' do
    subject(:notification) { create(:notification, :for_friendship) }

    it 'saves the expected string in the message attribute' do
      result = notification.message
      name = notification.sender.name
      expect(result).to eq("#{name} accepted your friend request.")
    end
  end
end
