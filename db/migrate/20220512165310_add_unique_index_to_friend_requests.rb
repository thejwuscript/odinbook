class AddUniqueIndexToFriendRequests < ActiveRecord::Migration[7.0]
  def change
    add_index :friend_requests, [:requester_id, :requestee_id], unique: true
  end
end
