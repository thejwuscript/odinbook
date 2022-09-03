class AddDisplayNameToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :display_name, :string
  end
end
