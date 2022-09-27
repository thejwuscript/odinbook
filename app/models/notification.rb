class Notification < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  def save_notification(sender, receiver, message)
    self.sender = sender
    self.receiver = receiver
    self.message = message
    save
  end
end
