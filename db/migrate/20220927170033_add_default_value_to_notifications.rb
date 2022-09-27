class AddDefaultValueToNotifications < ActiveRecord::Migration[7.0]
  def change
    change_column_default :notifications, :user_read, from: nil, to: false
  end
end
