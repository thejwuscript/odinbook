class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.string :message
      t.boolean :user_read
      t.integer :notifiable_id
      t.string :notifiable_type

      t.timestamps
    end
  end
end
