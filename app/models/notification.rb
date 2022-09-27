class Notification < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  before_create :specify_message

  private

  def specify_message
    case notifiable_type
    when "FriendRequest"
      self.message = "#{sender.name} sent you a friend request."
    when ''
    else
    end
  end
end
