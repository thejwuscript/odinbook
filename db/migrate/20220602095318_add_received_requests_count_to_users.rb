class AddReceivedRequestsCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :received_requests_count, :integer
  end
end
