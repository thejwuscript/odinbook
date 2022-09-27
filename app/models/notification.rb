class Notification < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  def save_notification(sender, receiver, message)
  end
end
