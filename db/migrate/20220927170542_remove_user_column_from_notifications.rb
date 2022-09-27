class RemoveUserColumnFromNotifications < ActiveRecord::Migration[7.0]
  def change
    remove_reference :notifications, :user, null: false, foreign_key: true
  end
end
